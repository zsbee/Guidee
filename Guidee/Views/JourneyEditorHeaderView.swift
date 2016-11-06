import UIKit

protocol JourneyEditorHeaderViewDelegate {
    func header_cancelButtonTapped()
    func header_saveButtonTapped()
}

class JourneyEditorHeaderView: UIView {
    
    public var delegate: JourneyEditorHeaderViewDelegate?
    
    let cancelButton: UIButton
    let saveButton: UIButton
    
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        self.cancelButton = UIButton(type: .system)
        self.saveButton = UIButton(type: .system)
        
        super.init(frame: frame)
        
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.00), for: .normal)
        self.cancelButton.addTarget(self, action: #selector(EditTextHeaderView.closeTapped), for: .touchUpInside)
        
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.setTitleColor(UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.00), for: .normal)
        self.saveButton.addTarget(self, action: #selector(EditTextHeaderView.saveTapped), for: .touchUpInside)
        
        
        
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        self.titleLabel.text = "Create Journey"
        
        
        self.addSubview(titleLabel)
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.cancelButton.sizeToFit()
        self.saveButton.sizeToFit()
        self.titleLabel.sizeToFit()
        
        self.cancelButton.frame = CGRect(x: 16,
                                         y: 25,
                                         width: self.cancelButton.frame.width,
                                         height: self.cancelButton.frame.height)
        
        
        self.saveButton.frame = CGRect(x: self.frame.width - 16 - self.saveButton.frame.width,
                                       y: 25,
                                       width: self.saveButton.frame.width,
                                       height: self.saveButton.frame.height)
        
        self.titleLabel.frame = CGRect(x: self.frame.width/2 - self.titleLabel.frame.width/2,
                                       y: 5 + self.frame.height/2 - self.titleLabel.frame.height/2,
                                       width: self.titleLabel.frame.width,
                                       height: self.titleLabel.frame.height)
    }
    
    func closeTapped() {
        self.delegate?.header_cancelButtonTapped()
    }
    
    func saveTapped() {
        self.delegate?.header_saveButtonTapped()
    }
    
}
