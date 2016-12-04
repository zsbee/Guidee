import UIKit
import AsyncDisplayKit

class PlaceholderNode: ASCellNode {
    let placeholderTextNode: ASTextNode

    override init() {
        self.placeholderTextNode = ASTextNode()
        placeholderTextNode.attributedText = NSAttributedString(string: "No comments yet, add yours?", attributes: TextStyles.getSummaryTextFontAttributes())
        super.init()
        self.addSubnode(self.placeholderTextNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetSpec = ASInsetLayoutSpec()

        insetSpec.insets = UIEdgeInsetsMake(0, 16, 0, 16)
        insetSpec.setChild(self.placeholderTextNode, at: 0)
    
        return insetSpec
    }
    
}
