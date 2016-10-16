import UIKit

protocol GuideEventHeaderViewDelegate {
    func header_closeButtonTapped()
}

class GuideEventHeaderView: UIView {

    let heartIconButton: UIButton
    let heartCounter: UILabel
    let eventName: UILabel
    let closeButton: UIButton

    public var delegate: GuideEventHeaderViewDelegate?
    
    override init(frame: CGRect) {
        self.heartIconButton = UIButton(type: .custom)
        self.heartCounter = UILabel()
        self.eventName = UILabel()
        self.closeButton = UIButton(type: .custom)

        super.init(frame: frame)

        // Configure views
        self.heartIconButton.setImage(UIImage(named: "Heart"), for: .normal)
        
        self.closeButton.setImage(UIImage(named: "BackdownArrow"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(GuideEventHeaderView.closeTapped), for: .touchUpInside)
        
        self.heartCounter.textColor = UIColor.black
        self.heartCounter.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightHeavy)
        self.heartCounter.text = "12"
        
        self.eventName.textColor = UIColor.black
        self.eventName.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        self.eventName.text = "Instant"
        self.eventName.textAlignment = .center;

        self.addSubview(heartIconButton)
        self.addSubview(heartCounter)
        self.addSubview(eventName)
        self.addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.heartIconButton.frame = CGRect(x: self.frame.width - 40 - 16, y: 10, width: 40, height: 26)
        self.heartCounter.frame = CGRect(x: self.frame.width - 40 - 4, y: 10+26, width: 40, height: 26)
        self.eventName.frame = CGRect(x: self.frame.width/2-75.0, y: 10, width: 150, height: 26)
        self.closeButton.frame = CGRect(x: 16, y: 10, width: 40, height: 26)
    }
    
    func closeTapped() {
        self.delegate?.header_closeButtonTapped()
    }
    
}
