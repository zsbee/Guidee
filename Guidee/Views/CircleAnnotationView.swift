import UIKit
import MapKit
import PINRemoteImage
import pop

class CircleAnnotationView: MKAnnotationView {

    let circleView: UIImageView
    let smallSize: CGFloat = 40
    let bigSize: CGFloat = 60
    lazy var calloutView: PinCalloutView = PinCalloutView(frame: CGRect(x: 0, y: 0, width: 205, height: 125))

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.circleView = UIImageView()
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.annotation = annotation as! GuideAnnotation
        
        self.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureView() {
        if let imageUrl = (self.annotation as? GuideAnnotation)?.imageUrl {
            let imgURL = NSURL(string: imageUrl)
            self.circleView.pin_setImage(from: imgURL as? URL)
            
            self.circleView.layer.minificationFilter = kCAFilterTrilinear
            self.circleView.layer.cornerRadius = self.smallSize / 2
            self.circleView.clipsToBounds = true
            self.circleView.layer.borderWidth = 3.0
            self.circleView.layer.borderColor = UIColor.white.cgColor
            self.circleView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            self.circleView.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.circleView.layer.shadowRadius = 5;
            self.circleView.frame = CGRect(x: self.frame.width/2-self.smallSize/2, y: self.frame.height/2-self.smallSize/2, width: self.smallSize, height: self.smallSize)
        }
        
        self.calloutView.alpha = 0
        self.calloutView.frame = CGRect(x: 30, y: -125+30, width: 205, height: 125)
        
        self.addSubview(self.circleView)
        self.addSubview(self.calloutView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if(selected) {
            let springAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            springAnimation!.toValue = NSValue(cgPoint: CGPoint(x: 1.5, y: 1.5))
            springAnimation!.velocity = NSValue(cgPoint: CGPoint(x: 2, y: 2))
            springAnimation!.springBounciness = 25
            self.circleView.pop_add(springAnimation, forKey: "bounce")
            
            let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnimation!.toValue = 1
            self.calloutView.pop_add(alphaAnimation, forKey: "alpha")
        }
        else{
            let springAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            springAnimation!.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
            springAnimation!.velocity = NSValue(cgPoint: CGPoint(x: 2, y: 2))
            springAnimation!.springBounciness = 25
            self.circleView.pop_add(springAnimation, forKey: "bounce")
            
            let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnimation!.toValue = 0
            self.calloutView.pop_add(alphaAnimation, forKey: "alpha")
        }
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//        if (hitView != self)
//        {
//            self.superview?.bringSubview(toFront: self)
//        }
//        return hitView;
//    }
//    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let isInsideCallout = self.calloutView.frame.contains(point) && self.calloutView.alpha == 1
//        
//        if (isInsideCallout) {
//            return false
//        }
//        
//        return super.point(inside: point, with: event)
//    }
}
