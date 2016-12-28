import UIKit
import Firebase

protocol DataListener {
	func dc_loveModelsDidUpdate()
}

class DataController: AnyObject {
    private let root = FIRDatabase.database().reference()
    
    private let journeys: FIRDatabaseReference
    private let users: FIRDatabaseReference
    private let editableJourney: FIRDatabaseReference
    private let comments: FIRDatabaseReference
	private var listeners: [DataListener] = [DataListener]()
    // cache
    private var currentUser: UserInfoModel?
    
    private init() {
        self.journeys = root.child("Journeys")
        self.users = root.child("Users")
        self.editableJourney = root.child("EditableJourney")
        self.comments = root.child("Comments")
    }
    
    static let sharedInstance: DataController = {
        let instance = DataController()
        return instance
    }()
    
    
    public func getJourneys(completionBlock: @escaping (GuideBaseModel) -> ()) {
        self.journeys.observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    if let modelDict = snapshot.value as? NSDictionary {
                        let model = GuideBaseModel(dictionary: modelDict, firID: snapshot.key)
                        completionBlock(model)
                    }
                } else {
                    print("We do not have values")
                }
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    public func getCurrentUserInfo(completionBlock: @escaping (UserInfoModel) -> ()) {
        if let loggedInUser = FIRAuth.auth()?.currentUser {
            self.users.child(loggedInUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! [String: AnyObject]
                let userInfoModel = UserInfoModel(dictionary: value)
                self.currentUser = userInfoModel
                completionBlock(userInfoModel)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    public func getCommentsForJourneyWithId(journeyID: String, completionBlock: @escaping ([CommentModel]) -> ()) {
        self.comments.child(journeyID).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()) {
                if let commentsRawDict = snapshot.value as? [String: AnyObject] {
                    let sortedCommentDict = commentsRawDict.sorted(by: { $0.0 > $1.0 })
                    
                    var commentModels = [CommentModel]()
                    for (_, commentDict) in sortedCommentDict {
                        let commentModel = CommentModel(dictionary: commentDict as! [String: AnyObject])
                        commentModels.append(commentModel)
                    }
                    
                    completionBlock(commentModels)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    public func getJourneysWithFIRids(idArray: [String], completionBlock: @escaping (GuideBaseModel) -> ()) {
        for idString in idArray {
            self.journeys.child(idString).observeSingleEvent(of: .value, with: { (snapshot) in
                if let modelDict = snapshot.value as? NSDictionary {
                    let model = GuideBaseModel(dictionary: modelDict, firID: snapshot.key)
                    completionBlock(model)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    public func getUsersWithFIRids(idArray: [String], completionBlock: @escaping (UserInfoModel) -> ()) {
        for idString in idArray {
            self.users.child(idString).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! [String: AnyObject]
                let userInfoModel = UserInfoModel(dictionary: value)
                completionBlock(userInfoModel)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    public func getEditableJourneyModel(completionBlock: @escaping (GuideBaseModel) -> ()) {
        self.editableJourney.observeSingleEvent(of: .value, with: { (snapshot) in
            if let modelDict = snapshot.value as? NSDictionary {
                let model = GuideBaseModel(dictionary: modelDict, firID: snapshot.key)
                completionBlock(model)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    public func uploadImageToFirebase(imageData: Data, completionBlock: @escaping (String?) -> ()) {
        let uuid = UUID().uuidString
        let path = "images/\(uuid).jpg"
        let storageRef = FIRStorage.storage().reference(withPath: path)
        
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        storageRef.put(imageData, metadata: uploadMetadata) { (metadata, error) in
            if(error != nil) {
                print("Uh oh, error while uploading! \(error?.localizedDescription)")
            } else {
                print("yaya, we have everything \(metadata?.downloadURL())")
                completionBlock(metadata?.downloadURL()?.absoluteString)
            }
        }
    }
    
    public func uploadCommentToFirebase(guideFirebaseID: String, comment: String) {
        guard let currentUser = self.currentUser else {
            return
        }
        
        let author = currentUser.name
        let avatar = currentUser.avatarUrl
        let comment = comment
        
        var dict = [String: AnyObject]()
        dict["author"] = author as AnyObject
        dict["avatarURL"] = avatar as AnyObject
        dict["comment"] = comment as AnyObject
        
        self.comments.child(guideFirebaseID).childByAutoId().setValue(dict)
    }
    
    public func saveGuideToFirebase(mutatedGuide: MutableGuideBaseModel, completionBlock: @escaping () -> ()) {
        self.journeys.childByAutoId().setValue(mutatedGuide.objectAsDictionary(), withCompletionBlock: {(error, ref) in
            let uniqueKey = ref.key
            // append user journeys 
            if let loggedInUser = FIRAuth.auth()?.currentUser {
                self.users.child(loggedInUser.uid).child("journeys").childByAutoId().setValue(uniqueKey)
                completionBlock()
            }
        })
    }
    
    public func createUserWithID(firUser: FIRUser) {
        // do not create new if already exists
        self.users.child(firUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                return
            } else {
                var defaultUserModel = [String: AnyObject]()
                
                if let avatarImage = firUser.photoURL?.absoluteString {
                    defaultUserModel["avatarUrl"] = avatarImage as AnyObject
                } else {
                    defaultUserModel["avatarUrl"] = "https://empty" as AnyObject
                }
                
                if let displayName = firUser.displayName {
                    defaultUserModel["name"] = displayName as AnyObject
                } else {
                    defaultUserModel["name"] = "John Doe" as AnyObject
                }
                
                defaultUserModel["summary"] = "Tap here to set an introduction about yourself!" as AnyObject
                
                defaultUserModel["following"] = ["0"] as AnyObject
                
                self.users.child(firUser.uid).setValue(defaultUserModel);
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
	
	public func likeJourneyWithId(key: String!) {
		self.journeys.child(key).runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
			if var journey = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
				var loved: Dictionary<String, Bool>
				loved = journey["loved"] as? [String : Bool] ?? [:]
				var lovedCount = journey["lovedCount"] as? Int ?? 0
				if let _ = loved[uid] {
					lovedCount -= 1
					loved.removeValue(forKey: uid)
					// Remove from users likes
					self.users.child(uid).child("loved").child(key).removeValue()
				} else {
					lovedCount += 1
					loved[uid] = true
					// Set users likes
					self.users.child(uid).child("loved").child(key).setValue(key)
				}
				journey["lovedCount"] = lovedCount as AnyObject?
				journey["loved"] = loved as AnyObject?
							
				// Set value and report transaction success
				currentData.value = journey
				self.updateListeners()
				return FIRTransactionResult.success(withValue: currentData)
			}
			return FIRTransactionResult.success(withValue: currentData)}) { (error, committed, snapshot) in
				if let error = error {
					print(error.localizedDescription)
					self.updateListeners()
				}
			}
	}
	
    public func getCurrentUserModel() -> UserInfoModel? {
        return self.currentUser
    }
	
	public func addListener(listener: DataListener) {
		self.listeners.append(listener);
	}
	
	private func updateListeners() {
		// for now, until we do not have other types this is ok. will extend with subscription types later if needed.
		for listener in self.listeners {
			listener.dc_loveModelsDidUpdate()
		}
	}
}
