import UIKit
import Firebase

class DataController: AnyObject {
    private let root = FIRDatabase.database().reference()
    
    private let journeys: FIRDatabaseReference
    
    private init() {
        self.journeys = root.child("Journeys")
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
                print(error)
        }
    }
    
    public func getCurrentUserInfo(completionBlock: @escaping (GuideBaseModel) -> ()) {
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
            print(error)
        }
    }
}
