import UIKit
import AsyncDisplayKit

class StaticMapCellNode: ASCellNode, MKMapViewDelegate {
    let mapNode = ASMapNode()
	
	// If there are no annotations, there will be one pin shown in the center. Else, no pin in the center, but annotations on map
	init(mapCenterCoordinate: CLLocationCoordinate2D, annotations: [CLLocationCoordinate2D]?) {
        super.init()
        
        self.mapNode.region = MKCoordinateRegionMakeWithDistance(mapCenterCoordinate, 20000, 20000)
        self.mapNode.isLiveMap = true
		
		if let anns = annotations {
			var mkannotations = [MKAnnotation]()
			var i = 0
			for coordinates in anns {
				i += 1
				let annotation = MKPointAnnotation()
				annotation.coordinate = coordinates
				annotation.title = "#\(i)"
				mkannotations.append(annotation)
			}
			self.mapNode.annotations = mkannotations
		} else {
			let annotation = MKPointAnnotation()
			annotation.coordinate = mapCenterCoordinate
			self.mapNode.annotations = [annotation]
		}
		
        self.addSubnode(self.mapNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.mapNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 300)
        
        let containerSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 16, 0, 16), child: self.mapNode)
        return containerSpec
    }
    
    override func didLoad() {
        super.didLoad()
        self.mapNode.layer.cornerRadius = 10
        self.mapNode.layer.masksToBounds = true
    }
}
