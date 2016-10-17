public class GuideEventDetailModel: AnyObject {
    private let title: String
    private let summary: String
    private let carouselModels: [CarouselItemModel]
    
    public init(title: String, summary: String, carouselModels: [CarouselItemModel]) {
        self.title = title
        self.summary = summary
        self.carouselModels = carouselModels
    }
}
