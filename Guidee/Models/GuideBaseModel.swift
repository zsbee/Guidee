public class GuideBaseModel: AnyObject {
    
    public let identifier: String
    public let title: String
    public let coverImageUrl: String
    public let summary: String
    public let eventModels: [GuideEventDetailModel]
    public let annotationModel: GuideAnnotation
    public let userAvatarUrl: String
    
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
