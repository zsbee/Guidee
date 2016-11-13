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
        self.users.child("0").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! [String: AnyObject]
            let userInfoModel = UserInfoModel(dictionary: value)
            self.currentUser = userInfoModel
            completionBlock(userInfoModel)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    public func getCommentsForJourneyWithId(journeyID: String, completionBlock: @escaping ([CommentModel]) -> ()) {
        self.comments.child(journeyID).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()) {
                let commentsRawArray = snapshot.value as! [[String: AnyObject]]
                
                var commentModels = [CommentModel]()
                for commentDict in commentsRawArray {
                    let commentModel = CommentModel(dictionary: commentDict)
                    commentModels.append(commentModel)
                }
                
                completionBlock(commentModels)
            }
            else {
                print("snapshot does not exist")
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
    
    public func saveGuideToFirebase(mutatedGuide: MutableGuideBaseModel) {
        self.journeys.childByAutoId().setValue(mutatedGuide.objectAsDictionary())
    }
    
    public func getCurrentUserModel() -> UserInfoModel? {
        return self.currentUser
    }
}
