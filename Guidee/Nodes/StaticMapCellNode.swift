import UIKit
import AsyncDisplayKit

class StaticMapCellNode: ASCellNode, MKMapViewDelegate {
    let mapNode = ASMapNode()
    
    init(mapCenterCoordinate: CLLocationCoordinate2D) {
        super.init()
        
        self.mapNode.region = MKCoordinateRegionMakeWithDistance(mapCenterCoordinate, 2000000, 2000000)
        self.mapNode.isLiveMap = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapCenterCoordinate
        
        self.mapNode.annotations = [annotation]
        
        self.addSubnode(self.mapNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.mapNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: 300)
        
        let containerSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 16, 0, 16), child: self.mapNode)
        return containerSpec
    }
    
    override func didLoad() {
        super.didLoad()
        self.mapNode.layer.cornerRadius = 10
        self.mapNode.layer.masksToBounds = true
    }
}
