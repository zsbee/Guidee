import UIKit
import pop

protocol ProfileHeaderViewDelegate {
	func header_closeButtonTapped()
	func header_followButtonTapped()
}

class ProfileHeaderView: UIView {
	
	let followIconButton: UIButton
	let editButton: UIButton
	
	let closeButton: UIButton
	let blurEffect = UIBlurEffect(style: .extraLight)
	let blurEffectView: UIVisualEffectView
	// states
	var isFollowed: Bool = false
	
	private var editingMode = false
	
	public var delegate: ProfileHeaderViewDelegate?
	
	override init(frame: CGRect) {
		self.followIconButton = UIButton(type: .custom)
		self.closeButton = UIButton(type: .custom)
		self.editButton = UIButton(type: .system)
		
		self.blurEffectView = UIVisualEffectView(effect: blurEffect)
		
		super.init(frame: frame)
		
		// Configure views
		//self.followIconButton.setImage(UIImage(named: "HeartStroke"), for: .normal)
		//self.followIconButton.addTarget(self, action: #selector(ProfileHeaderView.followTapped), for: .touchUpInside)
		self.followIconButton.setTitle("Follow", for: .normal)
		self.followIconButton.setTitleColor(UIColor(red:0.58, green:0.84, blue:0.30, alpha:1.00), for: .normal)
		self.followIconButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		self.followIconButton.addTarget(self, action: #selector(ProfileHeaderView.followTapped), for: .touchUpInside)
		
		self.closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
		self.closeButton.addTarget(self, action: #selector(ProfileHeaderView.closeTapped), for: .touchUpInside)
		
		self.addSubview(blurEffectView)
		self.addSubview(followIconButton)
		self.addSubview(closeButton)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		self.blurEffectView.frame = self.frame
		self.followIconButton.frame = CGRect(x: self.frame.width - self.followIconButton.intrinsicContentSize.width - 16, y: 25, width: self.followIconButton.intrinsicContentSize.width, height: 26)
		self.closeButton.frame = CGRect(x: 16, y: 19, width: 40, height: 40)
	}
	
	func closeTapped() {
		self.delegate?.header_closeButtonTapped()
	}
	
	func followTapped() {
		self.delegate?.header_followButtonTapped()

		self.isFollowed = !isFollowed
	}
	
	public func updateIconisFollowed(isFollowed: Bool) {
		self.isFollowed = isFollowed
		
		if(self.isFollowed) {
			self.followIconButton.setTitle("Unfollow", for: .normal)
			self.followIconButton.setTitleColor(UIColor.red, for: .normal)
		} else {
			self.followIconButton.setTitle("Follow", for: .normal)
			self.followIconButton.setTitleColor(UIColor(red:0.58, green:0.84, blue:0.30, alpha:1.00), for: .normal)
		}
		self.setNeedsLayout()
	}
	
}
