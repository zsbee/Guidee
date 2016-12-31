import UIKit
import AsyncDisplayKit

protocol MapCellNodeDelegate {
    func mapCenterDidUpdateWithCoordinates(coordinates: CLLocationCoordinate2D)
}

class MapCellNode: ASCellNode, MKMapViewDelegate {
    let mapNode = ASMapNode()
    
    let pinNode = ASImageNode()
    
    public var delegate: MapCellNodeDelegate?
    
    init(mapCenterCoordinate: CLLocationCoordinate2D) {
        super.init()
        
        self.mapNode.region = MKCoordinateRegionMakeWithDistance(mapCenterCoordinate, 2000000, 2000000)
        
        self.mapNode.mapDelegate = self
        self.mapNode.isLiveMap = true
        
        self.pinNode.image = UIImage(named: "mapPin")
        
        self.addSubnode(self.mapNode)
        self.addSubnode(self.pinNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.mapNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 300)
        
        let centerLayoutSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumX, child: self.pinNode)
        let overlayLayoutSpec = ASOverlayLayoutSpec(child: self.mapNode, overlay: centerLayoutSpec)
        
        let containerSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 16, 0, 16), child: overlayLayoutSpec)
        
        return containerSpec
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.delegate?.mapCenterDidUpdateWithCoordinates(coordinates: mapView.centerCoordinate)
        self.pinNode.view.clipsToBounds = false
    }
    
    
    override func didLoad() {
        super.didLoad()
        self.mapNode.layer.cornerRadius = 10
        self.mapNode.layer.masksToBounds = true
    }
}
