import UIKit
import MapKit

protocol CustomMapViewDelegate {
   func customMapView_shouldNavigateWithAnnotation(annotation: GuideAnnotation?)
}

class CustomMapView: MKMapView {
    
    var began = false
    var ended = true
    var calloutViewFrame: CGRect?
    var annotation: GuideAnnotation?
    
    var customDelegate: CustomMapViewDelegate?
    
    init(customDelegate: CustomMapViewDelegate?) {
        if let customD = customDelegate {
            self.customDelegate = customD
        }
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                    self.customDelegate?.customMapView_shouldNavigateWithAnnotation(annotation: self.annotation)
                    
                }
            }
        }
        
        super.touchesEnded(touches, with: event)
    }
}
