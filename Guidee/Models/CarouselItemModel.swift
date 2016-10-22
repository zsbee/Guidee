public class CarouselItemModel: AnyObject {
    
    public enum CarouselItemType {
        case image
        case youtube
    }
    
    public let imageURL: String?
    public let videoID: String?
    public let type: CarouselItemType
    
    public init(imageURL: String?, videoId: String?) {
        self.imageURL = imageURL
        self.videoID = videoId
        
        if (imageURL != nil && videoId != nil) {
            assert(false, "Item is not valid, either it should be an image or a video, not both, nil the one you dont need")
        }
        
        if (imageURL != nil) {
            self.type = .image
        } else {
            self.type = .youtube
        }
        
    }
}
