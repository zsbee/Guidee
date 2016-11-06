import UIKit
import SAMTextView

class EditTextViewController: UIViewController, EditTextHeaderViewDelegate, UITextViewDelegate {

    let textView = SAMTextView()
    let headerView = EditTextHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.delegate = self
        self.textView.placeholder = "Tap to edit"
        
        self.view.addSubview(textView)
        self.view.addSubview(headerView)
        
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        self.textView.frame = CGRect(x: 10, y: 60, width: self.view.frame.size.width-10, height: self.view.frame.size.height - 60)
    }
    
    func header_cancelButtonTapped() {
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func header_saveButtonTapped() {
        print("save me pleasee")
        
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
}
