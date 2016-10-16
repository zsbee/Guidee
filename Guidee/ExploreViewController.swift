import UIKit

class ExploreViewController: UIViewController {

    let testBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testBtn.setTitle("Open Event", for: .normal)
        testBtn.frame = CGRect(x: 50, y: 100, width: 100, height: 100)
        
        //testBtn.addTarget(self, action: #selector(ExploreViewController.pressed(_:)), for: .TouchUpInside)
        self.view.addSubview(testBtn)
    }
    
    private func pressed(sender: UIButton!) {
        print("heyho")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

