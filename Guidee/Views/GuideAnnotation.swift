import UIKit
import MapKit

public class GuideAnnotation: NSObject, MKAnnotation {
    public var identifier: String
    public var title: String?
    public var coordinate: CLLocationCoordinate2D
    public let imageUrl: String
    public let likes: Int
    
    public var calloutView: PinCalloutView?
    
	public init(dictionary: NSDictionary, likes: Int) {
        self.identifier = (dictionary["identifier"] as! NSString) as String
        self.likes = likes
        self.imageUrl = (dictionary["imageURL"] as! NSString) as String
        self.title = (dictionary["title"] as! NSString) as String
		
        let locationDict = (dictionary["location"] as! NSDictionary)
        let latitude = (locationDict["latitude"] as! NSNumber) as Double
        let longitude = (locationDict["longitude"] as! NSNumber) as Double
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.coordinate = coordinates

        super.init()
    }
    
    public init(identifier: String, title: String?, likes: Int, coordinate: CLLocationCoordinate2D, imageUrl: String) {
        if let title = title {
            self.title = title
        }
        
        self.identifier = identifier
        self.likes = likes
        self.imageUrl = imageUrl
        self.coordinate = coordinate
        
        super.init()
    }
    
    public func objectAsDictionary() -> [String: AnyObject] {
        var dict = [String:AnyObject]()
        
        dict["identifier"] = self.identifier as AnyObject?
        dict["imageURL"] = DataController.sharedInstance.getCurrentUserModel()?.avatarUrl as AnyObject?
        dict["likes"] = 0 as AnyObject?
        dict["location"] = self.locationDictionary() as AnyObject?
        dict["title"] = self.title as AnyObject?
            
        return dict;
    }
    
    private func locationDictionary() -> [String:AnyObject] {
        var dict = [String:AnyObject]()
        
        dict["latitude"] = self.coordinate.latitude as AnyObject?
        dict["longitude"] = self.coordinate.longitude as AnyObject?
        
        return dict
    }

    
}
