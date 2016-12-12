import UIKit
import MapKit
import Firebase
import FBSDKCoreKit
import Onboard

class ExploreViewController: UIViewController, MKMapViewDelegate, CustomMapViewDelegate, ExploreheaderViewDelegate {
    var mapView: CustomMapView!
    var allGuides: [GuideBaseModel]! = [GuideBaseModel]()
    
    let headerView = ExploreHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataController.sharedInstance.getJourneys { (model) in
            // This gets called for every Journey
            self.allGuides.append(model)
            self.mapView.addAnnotation(model.annotationModel)
        }
        
        self.headerView.delegate = self
        
        self.mapView = CustomMapView(customDelegate: self)
        mapView.delegate = self
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.headerView)
        
        DataController.sharedInstance.getCurrentUserInfo(completionBlock: { (userModel) in
            // nothing
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (FBSDKAccessToken.current() == nil) {
            // Video
            let bundle = Bundle.main
            let moviePath = bundle.path(forResource: "OnboardingVid", ofType: "mp4")
            let movieURL = NSURL(fileURLWithPath: moviePath!)
            
            // User is logged in, do work such as go to next view controller.
            let loginVC = LoginViewController()
            let onboardingVC: OnboardingViewController! = OnboardingViewController(backgroundVideoURL: movieURL as URL!, contents: [loginVC])
            self.present(onboardingVC, animated: false, completion: nil)
        }
    }
    
    public func selected(sender: UIButton!) {
        let vc = GuideHomeViewController()
        // vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
    }
    
    // MKMapKitDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? GuideAnnotation {
            let identifier = annotation.identifier
            var view: CircleAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CircleAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = CircleAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vc = GuideHomeViewController()
        // vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true, completion:nil)
    }
    
    func customMapView_shouldNavigateWithAnnotation(annotation: GuideAnnotation?) {
        if let annotation = annotation {
            if let baseModel = self.getModelWithId(annotID: annotation.identifier) {
                let vc = GuideHomeViewController()
                vc.baseModel = baseModel
                
                self.present(vc, animated: true, completion:nil)
            }
        }
    }
    
    private func getModelWithId(annotID: String) -> GuideBaseModel? {
        for model in self.allGuides {
            if (model.identifier == annotID) {
                return model
            }
        }
        
        return nil
    }
    
    func addButtonDidTap() {
        let vc = JourneyEditorViewController()
        vc.mapCenter = self.mapView.centerCoordinate
        self.present(vc, animated: true, completion:nil)
    }
}

