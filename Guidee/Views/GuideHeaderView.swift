import UIKit
import pop

protocol GuideHeaderViewDelegate {
    func header_closeButtonTapped()
    func header_heartButtonTapped()
	func header_editButtonTapped()
}

class GuideHeaderView: UIView {
    
    let heartIconButton: UIButton
	let editButton: UIButton
	
    let closeButton: UIButton
    let blurEffect = UIBlurEffect(style: .extraLight)
    let blurEffectView: UIVisualEffectView
    // states
    var isLoved: Bool = false
	
	private var editingMode = false
	
    public var delegate: GuideHeaderViewDelegate?
    
    override init(frame: CGRect) {
        self.heartIconButton = UIButton(type: .custom)
        self.closeButton = UIButton(type: .custom)
		self.editButton = UIButton(type: .system)

        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
		
        super.init(frame: frame)
        
        // Configure views
        self.heartIconButton.setImage(UIImage(named: "HeartStroke"), for: .normal)
        self.heartIconButton.addTarget(self, action: #selector(GuideHeaderView.heartTapped), for: .touchUpInside)

		self.editButton.setTitle("Edit", for: .normal)
		self.editButton.setTitleColor(UIColor.red, for: .normal)
		self.editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		self.editButton.addTarget(self, action: #selector(GuideHeaderView.editTapped), for: .touchUpInside)
		
        self.closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(GuideHeaderView.closeTapped), for: .touchUpInside)
		
        self.addSubview(blurEffectView)
        self.addSubview(heartIconButton)
		self.addSubview(editButton)
        self.addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.blurEffectView.frame = self.frame
        self.heartIconButton.frame = CGRect(x: self.frame.width - 40 - 16, y: 25, width: 40, height: 26)
		self.editButton.frame = CGRect(x: self.frame.width - self.editButton.intrinsicContentSize.width - 16, y: 25, width: self.editButton.intrinsicContentSize.width, height: 26)
        self.closeButton.frame = CGRect(x: 16, y: 19, width: 40, height: 40)
    }
    
    func closeTapped() {
        self.delegate?.header_closeButtonTapped()
    }
	
	func editTapped() {
		self.delegate?.header_editButtonTapped()
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
	
	public func setIsEditEnabled(editingMode: Bool) {
		self.editingMode = editingMode
		
		if (self.editingMode == true) {
			self.heartIconButton.isHidden = true
			self.editButton.isHidden = false
		} else {
			self.heartIconButton.isHidden = false
			self.editButton.isHidden = true
		}
	}
	
	public func updateIconIsLoved(isLoved: Bool) {
		if(isLoved) {
			self.heartIconButton.setImage(UIImage(named: "HeartFill"), for: .normal)
		} else {
			self.heartIconButton.setImage(UIImage(named: "HeartStroke"), for: .normal)
		}
	}
	
}
