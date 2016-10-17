import Foundation
import UIKit
import AsyncDisplayKit

class GuideHeaderCellNode: ASCellNode {
    
    let titleNode: ASTextNode = ASTextNode()
    let coverImageUrl: String
    let coverImageNode: ASNetworkImageNode = ASNetworkImageNode() //https://postimg.org/image/v4hz35izx/
    
    init(coverImageUrl: String, attributedText: NSAttributedString) {
        
        self.coverImageUrl = coverImageUrl
        super.init()
        
        titleNode.attributedText = attributedText
        titleNode.maximumNumberOfLines = 3
                
        self.addSubnode(coverImageNode)
        self.addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.coverImageNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: 300)
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [spacer, titleNode])
        
        let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 32, right: 0), child: verticalStack)
        
        let overlaySpec: ASOverlayLayoutSpec = ASOverlayLayoutSpec(child:self.coverImageNode, overlay: insetSpec)
        
        return overlaySpec
    }
    
    override func fetchData() {
        super.fetchData()
        if let url = NSURL(string: self.coverImageUrl) {
            self.coverImageNode.setURL(url as URL, resetToDefault: true)
        }
    }
    
}
