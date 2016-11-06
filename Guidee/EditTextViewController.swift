import UIKit
import SAMTextView

protocol EditTextViewControllerDelegate {
    func editTextViewController_saveTappedWithString(string: String, sectionIndex: Int)
}

class EditTextViewController: UIViewController, EditTextHeaderViewDelegate, UITextViewDelegate {

    let textView = SAMTextView()
    let headerView = EditTextHeaderView()
    public var delegate: EditTextViewControllerDelegate?
    public var viewModel: EditTextSetupViewModel!
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.delegate = self
        self.headerView.titleLabel.text = self.viewModel.title
        self.textView.placeholder = self.viewModel.placeHolder
        self.textView.text = self.viewModel.text
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
        self.delegate?.editTextViewController_saveTappedWithString(string: self.textView.text, sectionIndex: self.viewModel.sectionIndex)
        
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
}
