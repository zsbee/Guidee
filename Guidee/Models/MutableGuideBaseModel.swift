import Foundation

public class MutableGuideBaseModel: AnyObject {
    public var identifier: String
    public var title: String
    public var coverImageUrl: String
    public var summary: String
    public var eventModels: [GuideEventDetailModel]
    public var annotationModel: GuideAnnotation
    public var userAvatarUrl: String
    
    public init(dictionary: NSDictionary) {
        self.identifier = (dictionary["identifier"] as! NSString) as String
        self.title = (dictionary["title"] as! NSString) as String
        self.summary = (dictionary["summary"] as! NSString) as String
        self.coverImageUrl = (dictionary["coverImageUrl"] as! NSString) as String
        self.userAvatarUrl = (dictionary["userAvatarUrl"] as! NSString) as String
        
        if let detailModels = dictionary["eventModels"] as? NSArray {
            let models:NSMutableArray = NSMutableArray()
            for detailModel in detailModels {
                if let detailDict = detailModel as? NSDictionary {
                    models.add(GuideEventDetailModel(dictionary: detailDict))
                }
            }
            self.eventModels = models as NSArray as! [GuideEventDetailModel]
        } else {
            self.eventModels = [GuideEventDetailModel]()
        }
        
        self.annotationModel = GuideAnnotation(dictionary: dictionary["annotationModel"] as! NSDictionary)
    }
    
    public init(identifier: String, title: String, summary: String, coverImageUrl: String, userAvatarUrl: String, eventModels: [GuideEventDetailModel], annotationModel: GuideAnnotation) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.coverImageUrl = coverImageUrl
        self.eventModels = eventModels
        self.annotationModel = annotationModel
        self.userAvatarUrl = userAvatarUrl
    }

}
