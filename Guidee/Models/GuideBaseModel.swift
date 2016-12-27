import Foundation

public class GuideBaseModel: AnyObject {
    
    public let firebaseID: String
    public let identifier: String
    public let title: String
    public let coverImageUrl: String
    public let summary: String
    public let eventModels: [GuideEventDetailModel]
    public let annotationModel: GuideAnnotation
    public let userAvatarUrl: String
	public let lovedCount: Int
	public let loved: [String: AnyObject]
	
    public init(dictionary: NSDictionary, firID: String) {
        self.firebaseID = firID
        self.identifier = (dictionary["identifier"] as! NSString) as String
        self.title = (dictionary["title"] as! NSString) as String
        self.summary = (dictionary["summary"] as! NSString) as String
        self.coverImageUrl = (dictionary["coverImageUrl"] as! NSString) as String
        self.userAvatarUrl = (dictionary["userAvatarUrl"] as! NSString) as String
		
		if (dictionary["lovedCount"] != nil) {
			self.lovedCount = dictionary["lovedCount"] as! Int
		} else {
			self.lovedCount = 0
		}
		
		if (dictionary["loved"] != nil) {
			self.loved = dictionary["loved"] as! [String: AnyObject]
		} else {
			self.loved = [String : AnyObject]()
		}
		
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

		self.annotationModel = GuideAnnotation(dictionary: dictionary["annotationModel"] as! NSDictionary, likes: self.lovedCount)
    }
    
    public init(identifier: String, title: String, summary: String, coverImageUrl: String, userAvatarUrl: String, eventModels: [GuideEventDetailModel], annotationModel: GuideAnnotation) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.coverImageUrl = coverImageUrl
        self.eventModels = eventModels
        self.annotationModel = annotationModel
        self.userAvatarUrl = userAvatarUrl
        self.firebaseID = identifier
		self.lovedCount = 0
		self.loved = [String:AnyObject]()
    }
    
    public func mutableObject() -> MutableGuideBaseModel {
        return MutableGuideBaseModel(identifier: self.identifier, title: self.title, summary: self.summary, coverImageUrl: self.coverImageUrl, userAvatarUrl: self.userAvatarUrl, eventModels: self.eventModels, annotationModel: self.annotationModel)
    }
}
