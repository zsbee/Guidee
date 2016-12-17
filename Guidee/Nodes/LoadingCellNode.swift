import UIKit
import AsyncDisplayKit

class LoadingCellNode: ASCellNode {
    
    let loadingIndicatorImageNode: ASImageNode = ASImageNode()
    var rotation: CGFloat = 0
    
    override init() {
        super.init()
        loadingIndicatorImageNode.image = UIImage(named: "loadingIndicator")
        self.addSubnode(loadingIndicatorImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumY, child: loadingIndicatorImageNode)
        
        return centerSpec
    }

    
    override func didLoad() {
        super.didLoad()
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(self.rotate), userInfo: nil, repeats: true)
    }
    
    func rotate() {
        self.rotation = self.rotation + 0.25
        let loadingView = self.loadingIndicatorImageNode.view
        loadingView.transform = CGAffineTransform(rotationAngle: self.rotation);
    }
}
