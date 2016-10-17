public class GuideBaseModel: AnyObject {
    
    private let title: String
    private let coverImageUrl: String
    private let summary: String
    private let eventModels: [GuideEventDetailModel]
    
    public init(title: String, summary: String, coverImageUrl: String, eventModels: [GuideEventDetailModel]) {
        self.title = title
        self.summary = summary
        self.coverImageUrl = coverImageUrl
        self.eventModels = eventModels
    }
}
