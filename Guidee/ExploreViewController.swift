import UIKit

class ExploreViewController: UIViewController {

    let testBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testBtn.setTitle("Open Event", for: .normal)
        testBtn.titleLabel?.textAlignment = .center
        testBtn.frame = CGRect(x: self.view.frame.width/2 - 50, y: self.view.frame.height - 200, width: 100, height: 100)
        
        testBtn.addTarget(self, action: #selector(ExploreViewController.selected), for: .touchUpInside)
        self.view.addSubview(testBtn)        
    }
    
    public func selected(sender: UIButton!) {
        let vc = GuideHomeViewController()
        // vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        //_detailsViewController = (StoryViewController*)segue.destinationViewController;
        //[_detailsViewController setViewModel:_selectedStory];
    }

    
}

