import Foundation

public class MutableGuideEventDetailModel: AnyObject {
    public var title: String
    public var summary: String
    public var carouselModels: [CarouselItemModel]
    
    public init(dictionary: NSDictionary) {
        self.title = (dictionary["title"] as! NSString) as String
        self.summary = (dictionary["summary"] as! NSString) as String
        
        let carouselModels = dictionary["carouselModels"] as? NSArray as! [NSDictionary]
        let models:NSMutableArray = NSMutableArray()
        for carouselModel: NSDictionary in carouselModels {
            var image: String?
            var videoId: String?
            if (carouselModel["imageURL"] as? NSString != nil) {
                image = (carouselModel["imageURL"] as! NSString) as String
            }
            if (carouselModel["videoYoutubeId"] as? NSString != nil) {
                videoId = (carouselModel["videoYoutubeId"] as! NSString) as String
            }
            
            models.add(CarouselItemModel(imageURL: image, videoId: videoId))
        }
        self.carouselModels = models as NSArray as! [CarouselItemModel]
    }
    
    public init(title: String, summary: String, carouselModels: [CarouselItemModel]) {
        self.title = title
        self.summary = summary
        self.carouselModels = carouselModels
    }
    
    public func copy() -> GuideEventDetailModel {
        return GuideEventDetailModel(title: self.title, summary: self.summary, carouselModels: self.carouselModels)
    }
}
