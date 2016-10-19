import UIKit

class PinCalloutView: UIView {
    
    let backgroundView: UIView
    let titleLabel: UILabel = UILabel()
    let heartIcon: UIImageView = UIImageView()
    let heartCounter: UILabel = UILabel()
    let chevron: UIButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        self.backgroundView = UIView(frame: frame)
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.layer.cornerRadius = 8
        self.backgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.backgroundView.layer.shadowRadius = 5;
        self.backgroundView.layer.masksToBounds = false;
        
        self.chevron.setImage(UIImage(named:"RightArrow"), for: .normal)
        super.init(frame: frame)
        
        
        self.heartIcon.image = UIImage(named: "Heart")
        self.chevron.addTarget(self, action: #selector(self.navigateTapped), for: .touchUpInside)


        self.titleLabel.attributedText = NSAttributedString(string: "Coast visits in Palma de Mallorca", attributes: TextStyles.getEventCellHeaderAttributes())
        self.titleLabel.numberOfLines = 2
        
        
        self.heartCounter.attributedText = NSAttributedString(string: "142 likes", attributes: TextStyles.getHeartCounterAttributes())
        self.heartCounter.numberOfLines = 2
        
        self.addSubview(self.backgroundView)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.heartIcon)
        self.addSubview(self.heartCounter)
        self.addSubview(self.chevron)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.titleLabel.frame = CGRect(x: 10, y: 5, width: 185, height: 60)
        self.heartIcon.frame = CGRect(x: 10, y: 75, width: 23, height: 20)
        self.heartCounter.frame = CGRect(x: 23+10+4, y: 75, width: 150, height: 25)
        self.chevron.frame = CGRect(x: 180, y: 95, width: 13, height: 21)
    }
    
    func navigateTapped() {
        print("navigate")
    }
}
