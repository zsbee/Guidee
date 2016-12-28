import UIKit
import AsyncDisplayKit

protocol ProfileCellNodeDelegate {
    func profileCellNode_tapped();
}

class ProfileCellNode: ASCellNode {
    
    let nameNode: ASTextNode = ASTextNode()
    let summaryTextNode: ASTextNode = ASTextNode()
    
    let avatarUrl: String;
    let avatarSize: CGFloat = 60.0
    let avatarNode: ASNetworkImageNode = ASNetworkImageNode()
    
    var delegate: ProfileCellNodeDelegate?
    
    init(name: NSAttributedString, summary: NSAttributedString, avatarUrl: String) {
        self.avatarUrl = avatarUrl
        super.init()
        
        nameNode.attributedText = name
        nameNode.maximumNumberOfLines = 1
        nameNode.truncationMode = .byTruncatingTail
        
        summaryTextNode.attributedText = summary
        
        self.addSubnode(avatarNode)
        self.addSubnode(nameNode)
        self.addSubnode(summaryTextNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.avatarNode.style.preferredSize = CGSize(width: avatarSize, height: avatarSize)
        self.avatarNode.style.flexGrow = 0
        
        let rightVerticalStack = ASStackLayoutSpec(direction: .vertical, spacing: 4, justifyContent: .start, alignItems: .stretch, children: [nameNode, summaryTextNode])
        rightVerticalStack.style.flexShrink = 1
        
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [avatarNode, rightVerticalStack])
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 16, 0, 8), child: mainStack)
        
        return insetSpec
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        if let avatarUrl = NSURL(string: self.avatarUrl) {
            self.avatarNode.setURL(avatarUrl as URL, resetToDefault: true)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.avatarNode.layer.cornerRadius = self.avatarSize / 2
        self.avatarNode.clipsToBounds = true
        self.avatarNode.layer.borderWidth = 3.0
        self.avatarNode.layer.borderColor = UIColor.white.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileCellNode.nodeTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func nodeTapped() {
        self.delegate?.profileCellNode_tapped()
    }

}
