import UIKit
import pop

protocol GuideEventHeaderViewDelegate {
    func header_closeButtonTapped()
    func header_heartButtonTapped()
}

class GuideEventHeaderView: UIView {

    let heartIconButton: UIButton
    let heartCounter: UILabel
    let eventName: UILabel
    let closeButton: UIButton

    // states
    var isLoved: Bool = false
    
    public var delegate: GuideEventHeaderViewDelegate?
    
    override init(frame: CGRect) {
        self.heartIconButton = UIButton(type: .custom)
        self.heartCounter = UILabel()
        self.eventName = UILabel()
        self.closeButton = UIButton(type: .custom)

        super.init(frame: frame)

        // Configure views
        self.heartIconButton.setImage(UIImage(named: "Heart"), for: .normal)
        self.heartIconButton.setImage(UIImage(named: "HeartHighlighted"), for: .highlighted)
        self.heartIconButton.addTarget(self, action: #selector(GuideEventHeaderView.heartTapped), for: .touchUpInside)

        self.closeButton.setImage(UIImage(named: "BackdownArrow"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(GuideEventHeaderView.closeTapped), for: .touchUpInside)
        
        self.heartCounter.textColor = UIColor.black
        self.heartCounter.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightHeavy)
        self.heartCounter.text = "12"
        
        self.eventName.textColor = UIColor.black
        self.eventName.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        self.eventName.textAlignment = .center;

       // self.addSubview(heartIconButton)
        self.addSubview(heartCounter)
        self.addSubview(eventName)
        self.addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(title: String) {
        self.eventName.text = title
    }
    
    override func layoutSubviews() {
        self.heartIconButton.frame = CGRect(x: self.frame.width - 40 - 16, y: 10, width: 40, height: 26)
        self.heartCounter.frame = CGRect(x: self.frame.width - 40 - 4, y: 10+26, width: 40, height: 26)
        self.eventName.frame = CGRect(x: self.frame.width/2-110.0, y: 10, width: 220, height: 26)
        self.closeButton.frame = CGRect(x: 16, y: 10, width: 40, height: 26)
    }
    
    func closeTapped() {
        self.delegate?.header_closeButtonTapped()
    }
    
    func heartTapped() {
        self.delegate?.header_heartButtonTapped()
        
        
        let springAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        if(self.isLoved) {
            self.heartCounter.text = "12"
            springAnimation!.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
        } else {
            springAnimation!.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
            self.heartCounter.text = "13"
        }
        
        self.isLoved = !isLoved
        springAnimation!.velocity = NSValue(cgPoint: CGPoint(x: 2, y: 2))
        springAnimation!.springBounciness = 25
        self.heartIconButton.pop_add(springAnimation, forKey: "bounce")
    }
    

}
