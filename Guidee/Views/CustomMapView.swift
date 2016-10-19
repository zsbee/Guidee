import UIKit
import MapKit

class CustomMapView: MKMapView {    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for annotation in self.selectedAnnotations {
            if let annotation = annotation as? GuideAnnotation {
                let calloutView = annotation.calloutView
                let pinViewOptional = self.view(for: annotation)
                if let pinView = pinViewOptional {
                    let finalHitFrame = CGRect(x: pinView.frame.origin.x + 30, y:pinView.frame.origin.y - 125+30, width:205, height: 125)
                    let isInsideCallout = finalHitFrame.contains(point) && calloutView!.alpha == 1
                    
                    if (isInsideCallout) {
                        return false
                    }
                }
            }
            
        }
        return super.point(inside: point, with: event)
    }
    
}
