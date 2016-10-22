import UIKit
import MapKit

class ExploreViewController: UIViewController, MKMapViewDelegate, CustomMapViewDelegate {

    var mapView: CustomMapView!
    var allGuides: [GuideBaseModel]! = [GuideBaseModel]()
    
    let headerView = ExploreHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allGuides = self.mockedBaseModels()
        
        self.mapView = CustomMapView(customDelegate: self)
        mapView.delegate = self
        mapView.addAnnotations(allGuides.map({ (guideModel) -> GuideAnnotation in
            return guideModel.annotationModel
        }))
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.headerView)
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

    // navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        //_detailsViewController = (StoryViewController*)segue.destinationViewController;
        //[_detailsViewController setViewModel:_selectedStory];
    }
    
    
    // MKMapKitDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? GuideAnnotation {
            let identifier = "circlePin"
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Tap on Pin")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("Deselect pin")
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
    
    //MARK:- TEMPORARY
    private func mockedBaseModels() -> [GuideBaseModel] {
        var models = [GuideBaseModel]()
        
        let baseModel1 = GuideBaseModel(identifier: "elsoID",
                                        title: "Beaches of Mallorca",
                                        summary: "Collection of unspoilt beaches that only locals know of!",
                                        coverImageUrl: "https://i.ytimg.com/vi/pnr_-oU006o/maxresdefault.jpg",
                                        userAvatarUrl: "https://s9.postimg.org/dcvk1ggy7/avatar2.jpg",
                                        eventModels: GuideHomeViewController.getMockedModel1(),
                                        annotationModel: GuideAnnotation(identifier: "elsoID", title: "Beaches of Mallorca", subtitle: "Collection of beaches, unspoilt beaches and more...", likes:132, coordinate: CLLocationCoordinate2D(latitude: 39.49, longitude: 3.28), imageUrl: "https://i.imgsafe.org/7d5ce651e5.jpg"))
        
        models.append(baseModel1)
        
        return models
    }
    
    private func getModelWithId(annotID: String) -> GuideBaseModel? {
        for model in self.allGuides {
            if (model.identifier == annotID) {
                return model
            }
        }
        
        return nil
    }
}

