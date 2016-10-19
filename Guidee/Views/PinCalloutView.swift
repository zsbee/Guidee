import UIKit

class PinCalloutView: UIView {
    
    let backgroundView: UIView
    
    override init(frame: CGRect) {
        self.backgroundView = UIView(frame: frame)
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.layer.cornerRadius = 8
        self.backgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.backgroundView.layer.shadowRadius = 5;
        self.backgroundView.layer.masksToBounds = false;
        
        super.init(frame: frame)
        
        self.addSubview(self.backgroundView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
