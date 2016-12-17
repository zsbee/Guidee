import UIKit
import AsyncDisplayKit

class JourneyPlaceholderCellNode: ASCellNode {
    let placeholderTextNode: ASTextNode
    let imageNode:ASImageNode = ASImageNode()
    
    init(text: String) {
        self.placeholderTextNode = ASTextNode()
        placeholderTextNode.attributedText = NSAttributedString(string: text, attributes: TextStyles.getSummaryTextFontAttributes())
        super.init()
        
        self.imageNode.image = UIImage(named: "Placeholder")
        
        self.addSubnode(self.placeholderTextNode)
        self.addSubnode(self.imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [self.imageNode, self.placeholderTextNode])
        
        self.placeholderTextNode.style.flexShrink = 1
        
        let insetSpec = ASInsetLayoutSpec()
        
        insetSpec.insets = UIEdgeInsetsMake(0, 16, 0, 16)
        insetSpec.setChild(stackSpec, at: 0)
        
        return insetSpec
    }
}
