import UIKit
import MapKit

class GuideAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        if let title = title {
            self.title = title
        }
        
        if let subtitle = subtitle {
            self.subtitle = subtitle
        }
        
        self.coordinate = coordinate
        
        super.init()
    }
    
}
