import UIKit

class ExploreViewController: UIViewController {

    let testBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testBtn.setTitle("Open Event", for: .normal)
        testBtn.frame = CGRect(x: 16, y: 100, width: 100, height: 100)
        
        testBtn.addTarget(self, action: #selector(ExploreViewController.selected), for: .touchUpInside)
        self.view.addSubview(testBtn)
    }
    
    public func selected(sender: UIButton!) {        
        self.present(GuideEventDetailsViewController(), animated: true, completion:nil)

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

