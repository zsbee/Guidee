import Foundation
import AsyncDisplayKit

class GuideSummaryTextNode: ASCellNode {
    let textNode: ASTextNode = ASTextNode()
    
    init(attributedText: NSAttributedString) {
        
        super.init()
        
        textNode.attributedText = attributedText
        
        self.addSubnode(textNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16), child: textNode)
        
        return insetSpec
    }
    
}
