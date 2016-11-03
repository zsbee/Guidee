import UIKit
import Firebase

class DataController: AnyObject {
    private let root = FIRDatabase.database().reference()
    
    private let journeys: FIRDatabaseReference
    private let users: FIRDatabaseReference
    private let editableJourney: FIRDatabaseReference
    
    
    private init() {
        self.journeys = root.child("Journeys")
        self.users = root.child("Users")
        self.editableJourney = root.child("EditableJourney")
    }
    
    static let sharedInstance: DataController = {
        let instance = DataController()
    
        return instance
    }()
    
    
    public func getJourneys(completionBlock: @escaping (GuideBaseModel) -> ()) {
        self.journeys.observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    if let modelDict = snapshot.value as? NSDictionary {
                        let model = GuideBaseModel(dictionary: modelDict)
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
            completionBlock(userInfoModel)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    public func getJourneysWithFIRids(idArray: [String], completionBlock: @escaping (GuideBaseModel) -> ()) {
        for idString in idArray {
            self.journeys.child(idString).observeSingleEvent(of: .value, with: { (snapshot) in
                if let modelDict = snapshot.value as? NSDictionary {
                    let model = GuideBaseModel(dictionary: modelDict)
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
                let model = GuideBaseModel(dictionary: modelDict)
                completionBlock(model)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
