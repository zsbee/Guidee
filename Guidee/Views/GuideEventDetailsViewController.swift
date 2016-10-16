import UIKit

class GuideEventDetailsViewController: UIViewController, GuideEventHeaderViewDelegate {

    let headerView: GuideEventHeaderView = GuideEventHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.delegate = self
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(headerView)
    }
    
    override func viewDidLayoutSubviews() {
        self.headerView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Header
    func header_closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func header_heartButtonTapped() {
        
    }
    
}
