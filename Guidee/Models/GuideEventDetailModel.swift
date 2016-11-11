import Foundation

public class GuideEventDetailModel: AnyObject {
    public let title: String
    public let summary: String
    public let carouselModels: [CarouselItemModel]
    
    public init(dictionary: NSDictionary) {
        self.title = (dictionary["title"] as! NSString) as String
        self.summary = (dictionary["summary"] as! NSString) as String
    
        if let carouselModels = dictionary["carouselModels"] as? NSArray as? [NSDictionary] {
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
        else {
            self.carouselModels = [CarouselItemModel]()
        }
    }
    
    public init(title: String, summary: String, carouselModels: [CarouselItemModel]) {
        self.title = title
        self.summary = summary
        self.carouselModels = carouselModels
    }
    
    public func mutableObject() -> MutableGuideEventDetailModel {
        return MutableGuideEventDetailModel(title: self.title, summary: self.summary, carouselModels: self.carouselModels)
    }
    
    public func objectAsDictionary() -> [String: AnyObject] {
        var dict = [String:AnyObject]()
        
        dict["title"] = self.title as AnyObject?
        dict["summary"] = self.summary as AnyObject?
        dict["carouselModels"] = self.carouselModelsArray() as AnyObject?
        
        return dict;
    }

    private func carouselModelsArray() -> [[String:AnyObject]] {
        var array = [[String:AnyObject]]()
        
        for carouselModel in self.carouselModels {
            array.append(carouselModel.objectAsDictionary())
        }
        
        return array
    }
    
}
