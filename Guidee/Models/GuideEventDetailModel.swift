public class GuideEventDetailModel: AnyObject {
    public let title: String
    public let summary: String
    public let carouselModels: [CarouselItemModel]
    
    public init(title: String, summary: String, carouselModels: [CarouselItemModel]) {
        self.title = title
        self.summary = summary
        self.carouselModels = carouselModels
    }
}
