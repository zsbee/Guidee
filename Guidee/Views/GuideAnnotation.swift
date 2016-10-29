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
    
    public init(dictionary: NSDictionary) {
        self.identifier = (dictionary["identifier"] as! NSString) as String
        self.likes = (dictionary["likes"] as! NSNumber) as Int
        self.imageUrl = (dictionary["imageURL"] as! NSString) as String
        self.title = (dictionary["title"] as! NSString) as String
        self.subtitle = (dictionary["subtitle"] as! NSString) as String
        
        let locationDict = (dictionary["location"] as! NSDictionary)
        let latitude = (locationDict["latitude"] as! NSNumber) as Double
        let longitude = (locationDict["longitude"] as! NSNumber) as Double
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.coordinate = coordinates

        super.init()
    }
    
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
