import UIKit
import Firebase

class DataController: AnyObject {
    private let root = FIRDatabase.database().reference()
    
    private let journeys: FIRDatabaseReference
    private let users: FIRDatabaseReference
    private let editableJourney: FIRDatabaseReference
    private let comments: FIRDatabaseReference
    
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
            else {
                print("No comments for this guide")
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
        
        defaultUserModel["summary"] = "Fill in some introduction about yourself!" as AnyObject

        defaultUserModel["plans"] = ["1"] as AnyObject
        defaultUserModel["loves"] = ["1","1","0"] as AnyObject
        defaultUserModel["journeys"] = ["-KY_5ibbvxVhhLUTd5uO","1","0"] as AnyObject
        defaultUserModel["following"] = ["0"] as AnyObject
        
        self.users.child(firUser.uid).setValue(defaultUserModel);
    }
    
    public func getCurrentUserModel() -> UserInfoModel? {
        return self.currentUser
    }
}
