import UIKit

protocol ExploreheaderViewDelegate {
    func addButtonDidTap()
}

class ExploreHeaderView: UIView {

    let titleLabel: UILabel = UILabel()
    let addButton: UIButton = UIButton()
    
    let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    public var delegate: ExploreheaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        self.titleLabel.text = "Explore"
        
        
        self.addButton.setImage(UIImage(named:"addIcon"), for: .normal)
        self.addButton.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
        
        self.addSubview(blurEffectView)
        self.addSubview(titleLabel)
        self.addSubview(addButton)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.blurEffectView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.titleLabel.sizeToFit()
        self.titleLabel.frame = CGRect(x: self.frame.width/2 - self.titleLabel.frame.width/2,
                                       y: 5 + self.frame.height/2 - self.titleLabel.frame.height/2,
                                       width: self.titleLabel.frame.width,
                                       height: self.titleLabel.frame.height)
        
        self.addButton.frame = CGRect(x: self.frame.width - 32 - 8,
                                      y: self.frame.height/2 - 24/2 + 5,
                                      width: 24,
                                      height: 24)
    }
    
    func addButtonTapped() {
        self.delegate?.addButtonDidTap()
    }

}
