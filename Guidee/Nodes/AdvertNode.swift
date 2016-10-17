import UIKit
import AsyncDisplayKit

class AdvertNode: ASCellNode {
    let dummyNode: ASDisplayNode = ASDisplayNode()
    
    var cellSize: CGSize!
    
    override init() {
        super.init()
        
        self.addSubnode(dummyNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        dummyNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: 250)
        
        self.cellSize = CGSize(width:constrainedSize.max.width, height: 250)
        
        let spec = ASLayoutSpec()
        spec.setChild(dummyNode)
        
        return spec
    }
    
    override func didLoad() {
        super.didLoad()
        let advert = UIView(frame: CGRect(x: self.cellSize.width/2-150, y: 0, width: 300, height: 250))
        advert.backgroundColor = UIColor.lightGray
        
        let label = UILabel(frame: CGRect(x: self.cellSize.width/2-150 + 10, y: 120, width: 300, height: 30))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightHeavy)
        label.text = "This is a UILabel to test google Adverts"
        
        self.view.addSubview(advert)
        self.view.addSubview(label)
    }
    
}
