import UIKit
import MapKit

class GuideAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let imageUrl: String
    
    public var calloutView: PinCalloutView?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, imageUrl: String) {
        if let title = title {
            self.title = title
        }
        
        if let subtitle = subtitle {
            self.subtitle = subtitle
        }
        
        self.imageUrl = imageUrl
        self.coordinate = coordinate
        
        super.init()
    }
    
}
