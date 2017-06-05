import UIKit
import Firebase

enum SubscriptionType {
	case love
	case plan
	case journey
	case follow
}

protocol DataListener {
	func dc_loveModelsDidUpdate()
	func dc_journeyModelsDidUpdate()
	func dc_followModelsDidUpdate()
}

class DataController: AnyObject {
    private let root = FIRDatabase.database().reference()
    
    private let journeys: FIRDatabaseReference
    private let users: FIRDatabaseReference
    private let editableJourney: FIRDatabaseReference
    private let comments: FIRDatabaseReference
	private var listeners: [SubscriptionType:[DataListener]] = [SubscriptionType:[DataListener]]()
    private var currentUser: UserInfoModel?
	private var editModel: GuideBaseModel?
    
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
                let userInfoModel = UserInfoModel(dictionary: value, identifier: snapshot.key)
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
				let userInfoModel = UserInfoModel(dictionary: value, identifier: snapshot.key)
                completionBlock(userInfoModel)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
	
	public func getCachedEditableJourneyModel() -> GuideBaseModel? {
		return self.editModel
	}
	
    public func getEditableJourneyModel(completionBlock: @escaping (GuideBaseModel) -> ()) {
		if let editJourneyModel = editModel {
			completionBlock(editJourneyModel)
		} else {
			self.editableJourney.observeSingleEvent(of: .value, with: { (snapshot) in
				if let modelDict = snapshot.value as? NSDictionary {
					let model = GuideBaseModel(dictionary: modelDict, firID: snapshot.key)
					self.editModel = model
					completionBlock(model)
				}
			}) { (error) in
				print(error.localizedDescription)
			}
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
            } else {
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
	
	
	public func overrideGuideToFirebase(mutatedGuide: MutableGuideBaseModel, completionBlock: @escaping () -> ()) {
		self.journeys.child(mutatedGuide.firebaseID).setValue(mutatedGuide.objectAsDictionary(), withCompletionBlock: {(error, ref) in
			self.updateJourneyListeners()
			completionBlock()
		})
	}
	
	public func createUserWithID(firUser: FIRUser, avatarURL: String) {
        // do not create new if already exists
        self.users.child(firUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
				if (firUser.photoURL != firUser.providerData[0].photoURL) {
					self.overrideImage(firUser: firUser, snapshot: snapshot, avatarUrl: avatarURL)
				}
				return;
            } else {
				self.saveNewProfileData(firUser: firUser, avatarURL: avatarURL);
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
	
	private func overrideImage(firUser: FIRUser, snapshot: FIRDataSnapshot, avatarUrl: String)
	{
		var defaultUserModel = snapshot.value as! [String: AnyObject];

		defaultUserModel["avatarUrl"] = avatarUrl as AnyObject
		
		self.users.child(firUser.uid).setValue(defaultUserModel);
	}
	
	private func saveNewProfileData(firUser: FIRUser, avatarURL: String)
	{
		var defaultUserModel = [String: AnyObject]()
		
		defaultUserModel["avatarUrl"] = avatarURL as AnyObject
		
		if let displayName = firUser.displayName {
			defaultUserModel["name"] = displayName as AnyObject
		} else {
			defaultUserModel["name"] = "John Doe" as AnyObject
		}
		
		defaultUserModel["summary"] = "Tap here to set an introduction about yourself!" as AnyObject
		
		self.users.child(firUser.uid).setValue(defaultUserModel);
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
				self.updateLoveListeners()
				return FIRTransactionResult.success(withValue: currentData)
			}
			return FIRTransactionResult.success(withValue: currentData)}) { (error, committed, snapshot) in
				if let error = error {
					print(error.localizedDescription)
					self.updateLoveListeners()
				}
			}
	}
	
	public func followUserWithId(userId: String!) {
		self.users.child(userId).runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
			if var followedUser = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
				var followed: Dictionary<String, Bool>
				followed = followedUser["followedBy"] as? [String : Bool] ?? [:]
				var followedCount = followedUser["followedByCount"] as? Int ?? 0
				if let _ = followed[uid] {
					followedCount -= 1
					followed.removeValue(forKey: uid)
					// Remove from user from my followers
					self.users.child(uid).child("following").child(userId).removeValue()
				} else {
					followedCount += 1
					followed[uid] = true
					// Set users likes
					self.users.child(uid).child("following").child(userId).setValue(userId)
				}
				followedUser["followedByCount"] = followedCount as AnyObject?
				followedUser["followedBy"] = followed as AnyObject?
				
				// Set value and report transaction success
				currentData.value = followedUser
				self.updateFollowListeners()
				return FIRTransactionResult.success(withValue: currentData)
			}
			return FIRTransactionResult.success(withValue: currentData)}) { (error, committed, snapshot) in
				if let error = error {
					print(error.localizedDescription)
					self.updateFollowListeners()
				}
		}
	}
	
    public func getCurrentUserModel() -> UserInfoModel? {
        return self.currentUser
    }
	
	public func addListener(listener: DataListener, type:SubscriptionType) {
		if (self.listeners[type] != nil) {
			self.listeners[type]!.append(listener)
		} else {
			self.listeners[type] = [listener]
		}
	}
	
	private func updateJourneyListeners() {
		if let journeyListeners = self.listeners[.journey] {
			for listener in journeyListeners {
				listener.dc_journeyModelsDidUpdate()
			}
		}
	}
	
	private func updateLoveListeners() {
		if let loveListeners = self.listeners[.love] {
			for listener in loveListeners {
				listener.dc_loveModelsDidUpdate()
			}
		}
	}
	
	private func updateFollowListeners() {
		if let followListeners = self.listeners[.follow] {
			for listener in followListeners {
				listener.dc_followModelsDidUpdate()
			}
		}
	}
}
