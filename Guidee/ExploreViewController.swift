import UIKit
import MapKit

class ExploreViewController: UIViewController, MKMapViewDelegate, CustomMapViewDelegate {

    var mapView: CustomMapView!
    var allGuides: [GuideBaseModel]! = [GuideBaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allGuides = self.mockedBaseModels()
        
        self.mapView = CustomMapView(customDelegate: self)
        self.view.addSubview(self.mapView)
        mapView.delegate = self
        mapView.addAnnotations(allGuides.map({ (guideModel) -> GuideAnnotation in
            return guideModel.annotationModel
        }))
        
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
                                        title: "Palma Guide",
                                        summary: "Lorem Ipsum",
                                        coverImageUrl: "https://i.imgsafe.org/545a735254.jpg",
                                        userAvatarUrl: "https://s9.postimg.org/dcvk1ggy7/avatar2.jpg",
                                        eventModels: GuideHomeViewController.getMockedModel1(),
                                        annotationModel: GuideAnnotation(identifier: "elsoID", title: "Palme de Mallorca, best places to visit", subtitle: "Lorem Ipsum Dolor Sit amet", likes:132, coordinate: CLLocationCoordinate2D(latitude: 39.49, longitude: 3.28), imageUrl: "https://i.imgsafe.org/7d5ce651e5.jpg"))
        
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

