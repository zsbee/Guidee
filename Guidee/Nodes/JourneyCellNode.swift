import UIKit
import AsyncDisplayKit

class JourneyCellNode: ASCellNode {
    
    let titleNode: ASTextNode = ASTextNode()
    let coverImageUrl: String
    let coverImageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    init(coverImageUrl: String, title: NSAttributedString) {
        self.coverImageUrl = coverImageUrl
        super.init()
        
        titleNode.attributedText = title
        titleNode.maximumNumberOfLines = 3
        
        self.addSubnode(coverImageNode)
        self.addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.coverImageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 162)
        
        let spacer = ASDisplayNode()
        spacer.style.flexGrow = 1
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [spacer, self.titleNode])
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 8, 0), child: verticalStack)
        
        let overlaySpec: ASOverlayLayoutSpec = ASOverlayLayoutSpec(child:self.coverImageNode, overlay: insetSpec)
        
        return overlaySpec
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        if let url = NSURL(string: self.coverImageUrl) {
            self.coverImageNode.setURL(url as URL, resetToDefault: true)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.coverImageNode.layer.cornerRadius = 10
        self.coverImageNode.layer.masksToBounds = true
    }
}
    
