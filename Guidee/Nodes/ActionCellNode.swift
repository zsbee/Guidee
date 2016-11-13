import UIKit
import AsyncDisplayKit

protocol ActionCellNodeDelegate {
    func actionButtonTappedWithString(string: String)
}

class ActionCellNode: ASCellNode {
    let actionButtonNode: ASButtonNode = ASButtonNode()
    let actionTextNode: ASTextNode = ASTextNode()
    let actionString: String
    let delegate: ActionCellNodeDelegate
    
    init(actionStringNormal: NSAttributedString, actionStringHighlighted: NSAttributedString, delegate: ActionCellNodeDelegate) {
        self.delegate = delegate
        self.actionString = actionStringNormal.string
        super.init()
        
        actionButtonNode.setAttributedTitle(actionStringNormal, for: ASControlState.init(rawValue: 0))
        actionButtonNode.setAttributedTitle(actionStringHighlighted, for: .highlighted)

        actionButtonNode.addTarget(self, action: #selector(self.tapped), forControlEvents: .touchUpInside)
        
        
        self.addSubnode(actionButtonNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), child: actionButtonNode)
        
        return insetSpec
    }
    
    func tapped() {
        self.delegate.actionButtonTappedWithString(string: self.actionString)
    }
}
