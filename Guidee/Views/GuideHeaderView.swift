import UIKit
import pop

protocol GuideHeaderViewDelegate {
    func header_closeButtonTapped()
    func header_heartButtonTapped()
}

class GuideHeaderView: UIView {
    
    let heartIconButton: UIButton
    let closeButton: UIButton
    let blurEffect = UIBlurEffect(style: .extraLight)
    let blurEffectView: UIVisualEffectView
    // states
    var isLoved: Bool = false
    
    public var delegate: GuideHeaderViewDelegate?
    
    override init(frame: CGRect) {
        self.heartIconButton = UIButton(type: .custom)
        self.closeButton = UIButton(type: .custom)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(frame: frame)
        
        // Configure views
        self.heartIconButton.setImage(UIImage(named: "HeartStroke"), for: .normal)
        self.heartIconButton.addTarget(self, action: #selector(GuideHeaderView.heartTapped), for: .touchUpInside)

        self.closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(GuideHeaderView.closeTapped), for: .touchUpInside)
        
        
        self.addSubview(blurEffectView)
        self.addSubview(heartIconButton)
        self.addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.blurEffectView.frame = self.frame
        self.heartIconButton.frame = CGRect(x: self.frame.width - 40 - 16, y: 25, width: 40, height: 26)
        self.closeButton.frame = CGRect(x: 16, y: 19, width: 40, height: 40)
    }
    
    func closeTapped() {
        self.delegate?.header_closeButtonTapped()
    }
    
    func heartTapped() {
        self.delegate?.header_heartButtonTapped()
        
        
        let springAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        if(self.isLoved) {
            springAnimation!.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
        } else {
            springAnimation!.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
        }
        
        self.isLoved = !isLoved
        springAnimation!.velocity = NSValue(cgPoint: CGPoint(x: 2, y: 2))
        springAnimation!.springBounciness = 25
        self.heartIconButton.pop_add(springAnimation, forKey: "bounce")
    }
	
	public func updateIconIsLoved(isLoved: Bool) {
		if(isLoved) {
			self.heartIconButton.setImage(UIImage(named: "HeartFill"), for: .normal)
		} else {
			self.heartIconButton.setImage(UIImage(named: "HeartStroke"), for: .normal)
		}
	}
	
}
