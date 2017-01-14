import Foundation

public class MutableGuideBaseModel: AnyObject {
	public var firebaseID: String
    public var identifier: String
    public var title: String
    public var coverImageUrl: String
    public var summary: String
    public var eventModels: [GuideEventDetailModel]
    public var annotationModel: GuideAnnotation
    public var userAvatarUrl: String
	public var userID: String
    
	public init(identifier: String, firebaseID: String, title: String, summary: String, coverImageUrl: String, userAvatarUrl: String, eventModels: [GuideEventDetailModel], annotationModel: GuideAnnotation, userIdentifier: String) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.coverImageUrl = coverImageUrl
        self.eventModels = eventModels
        self.annotationModel = annotationModel
        self.userAvatarUrl = userAvatarUrl
		self.firebaseID = firebaseID
		self.userID = userIdentifier
    }
    
    public func objectAsDictionary() -> [String: AnyObject] {
        var dict = [String:AnyObject]()
        
        dict["identifier"] = self.identifier as AnyObject?
        dict["title"] = self.title as AnyObject?
        dict["coverImageUrl"] = self.coverImageUrl as AnyObject?
        dict["summary"] = self.summary as AnyObject?
        dict["userAvatarUrl"] = self.userAvatarUrl as AnyObject?
        dict["eventModels"] = self.eventModelsArray() as AnyObject
        dict["annotationModel"] = self.annotationModel.objectAsDictionary() as AnyObject?
        dict["userId"] = self.userID as AnyObject?
		
        return dict;
    }

    private func eventModelsArray() -> [[String:AnyObject]] {
        var array = [[String:AnyObject]]()
        
        for eventModel in self.eventModels {
            array.append(eventModel.objectAsDictionary())
        }
        
        return array
    }
}
