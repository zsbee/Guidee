import UIKit
import MapKit

class ExploreViewController: UIViewController, MKMapViewDelegate {

    let testBtn = UIButton(type: .system)
    let mapView = CustomMapView()
    var annotations: [GuideAnnotation]! = [GuideAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        annotations = self.mockedAnnotations()
        
        self.view.addSubview(self.mapView)
        mapView.delegate = self
        mapView.addAnnotations(annotations)
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
    
    func mockedAnnotations() -> [GuideAnnotation] {
        var annots = [GuideAnnotation]()
        
        annots.append(GuideAnnotation(title: "Cala Varques",
                                      subtitle: "Hidden Gem",
                                      coordinate: CLLocationCoordinate2D(latitude: 39.49, longitude: 3.28),
                                      imageUrl:"https://i.imgsafe.org/7d5ce651e5.jpg"))
        
        annots.append(GuideAnnotation(title: "Szabadsághíd",
                                      subtitle: "Woohoo...",
                                      coordinate: CLLocationCoordinate2D(latitude: 47.4856, longitude: 19.0546),
                                      imageUrl:"https://i.imgsafe.org/7d5ce651e5.jpg"))
        
        return annots
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
    
}

