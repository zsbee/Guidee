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
                                        annotationModel: GuideAnnotation(identifier: "elsoID", title: "Beaches of Mallorca", subtitle: "Collection of beaches, unspoilt beaches and more...", likes:132, coordinate: CLLocationCoordinate2D(latitude: 39.49, longitude: 3.28), imageUrl: "https://s9.postimg.org/dcvk1ggy7/avatar2.jpg"))
        
        let baseModel2 = GuideBaseModel(identifier: "masodikID",
                                        title: "Beautiful Thailand",
                                        summary: "Experience the livelihood of Thailand through beutiful unpoilt, touristless spots!",
                                        coverImageUrl: "https://newmedia.thomson.co.uk/live/vol/0/921d4b57639916341dfa76e38310ff7bc13b11e2/1080x608/web/ASIAFAREASTTHAILANDTHAILANDDES_000423KHAOLAKRES_002378.jpg",
                                        userAvatarUrl: "https://i.imgsafe.org/c9333b4e93.png",
                                        eventModels: GuideHomeViewController.getMockedModel2(),
                                        annotationModel: GuideAnnotation(identifier: "masodikID", title: "Unspoilt beaches", subtitle: "Experience the livelihood of Thailand through beutiful unpoilt, touristless spots!", likes:479, coordinate: CLLocationCoordinate2D(latitude: 6.5944565, longitude: 99.35871), imageUrl: "https://i.imgsafe.org/c9333b4e93.png"))
        
        let baseModel3 = GuideBaseModel(identifier: "harmadikID",
                                        title: "30 Things in Tobago",
                                        summary: "So when it comes to the Caribbean island of Tobago, you can say I’m a bit of an Island Connoisseur. Having spent 60 days exploring everything there is to see and do here I thought I would put together a list of my top picks. So here they are listed in no particular order.",
                                        coverImageUrl: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Englishmans-Bay-Tobago.jpg",
                                        userAvatarUrl: "https://yt3.ggpht.com/-IE9zWKgAAIA/AAAAAAAAAAI/AAAAAAAAAAA/MgaQTBTMi-0/s100-c-k-no-mo-rj-c0xffffff/photo.jpg",
                                        eventModels: GuideHomeViewController.getMockedModel3(),
                                        annotationModel: GuideAnnotation(identifier: "harmadikID", title: "30 Things in Tobago", subtitle: "Experience the livelihood of Thailand through beutiful unpoilt, touristless spots!", likes:1738, coordinate: CLLocationCoordinate2D(latitude: 11.248085, longitude: -60.6814262), imageUrl: "https://yt3.ggpht.com/-IE9zWKgAAIA/AAAAAAAAAAI/AAAAAAAAAAA/MgaQTBTMi-0/s100-c-k-no-mo-rj-c0xffffff/photo.jpg"))
        
        models.append(baseModel1)
        models.append(baseModel2)
        models.append(baseModel3)
        
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

