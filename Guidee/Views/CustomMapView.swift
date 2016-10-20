import UIKit
import MapKit

class CustomMapView: MKMapView {
    
    var began = false
    var ended = true
    var calloutViewFrame: CGRect?
    var annotation: GuideAnnotation?
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//        if (hitView == nil)
//        {
//            for annotation in self.selectedAnnotations {
//                if let annotation = annotation as? GuideAnnotation {
//                    let calloutView = annotation.calloutView
//                    let pinViewOptional = self.view(for: annotation)
//                    if let pinView = pinViewOptional {
//                        let finalHitFrame = CGRect(x: pinView.frame.origin.x + 30, y:pinView.frame.origin.y - 125+30, width:205, height: 125)
//                        let isInsideCallout = finalHitFrame.contains(point) && calloutView!.alpha == 1
//                        
//                        if (isInsideCallout) {
//                            return calloutView?.hitTest(point, with: event)
//                        }
//                    }
//                }
//            }
//        }
//        return super.hitTest(point, with: event);
//    }
//    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.calloutViewFrame = nil
        for annotation in self.selectedAnnotations {
            if let annotation = annotation as? GuideAnnotation {
                let calloutView = annotation.calloutView
                let pinViewOptional = self.view(for: annotation)
                if let pinView = pinViewOptional {
                    if (calloutView!.alpha == 1) {
                        calloutViewFrame = CGRect(x: pinView.frame.origin.x + 30, y:pinView.frame.origin.y - 125+30, width:205, height: 125)
                        let isInsideCallout = calloutViewFrame!.contains(touches.first!.location(in: self))
                        
                        if (isInsideCallout) {
                            self.began = true
                            self.annotation = annotation
                        }
                    }
                }
            }
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ended = false
        if let calloutViewFrame = self.calloutViewFrame {
            let isInsideCallout = calloutViewFrame.contains(touches.first!.location(in: self))
                    
            if (isInsideCallout) {
                self.ended = true
                
                if(self.began) {
                    for annotation in self.selectedAnnotations {
                        self.deselectAnnotation(annotation, animated: true)
                    }
                    
                    // post noti
                }
            }
        }
        
        super.touchesEnded(touches, with: event)
    }
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        for annotation in self.selectedAnnotations {
//            if let annotation = annotation as? GuideAnnotation {
//                let calloutView = annotation.calloutView
//                let pinViewOptional = self.view(for: annotation)
//                if let pinView = pinViewOptional {
//                    let finalHitFrame = CGRect(x: pinView.frame.origin.x + 30, y:pinView.frame.origin.y - 125+30, width:205, height: 125)
//                    let isInsideCallout = finalHitFrame.contains(point) && calloutView!.alpha == 1
//                    
//                    if (isInsideCallout) {
//                        return false
//                    }
//                }
//            }
//            
//        }
//        return super.point(inside: point, with: event)
//    }
    
}
