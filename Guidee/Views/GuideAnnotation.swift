import UIKit
import MapKit

public class GuideAnnotation: NSObject, MKAnnotation {
    public let identifier: String
    public var title: String?
    public var subtitle: String?
    public let coordinate: CLLocationCoordinate2D
    public let imageUrl: String
    public let likes: Int
    
    public var calloutView: PinCalloutView?
    
    public init(identifier: String, title: String?, subtitle: String?, likes: Int, coordinate: CLLocationCoordinate2D, imageUrl: String) {
        if let title = title {
            self.title = title
        }
        
        if let subtitle = subtitle {
            self.subtitle = subtitle
        }
        
        self.identifier = identifier
        self.likes = likes
        self.imageUrl = imageUrl
        self.coordinate = coordinate
        
        super.init()
    }
    
}
