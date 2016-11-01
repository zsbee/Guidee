import UIKit
import AsyncDisplayKit

class ProfileCellNode: ASCellNode {
    
    let nameNode: ASTextNode = ASTextNode()
    let summaryTextNode: ASTextNode = ASTextNode()
    
    let avatarUrl: String;
    let avatarSize: CGFloat = 60.0
    let avatarNode: ASNetworkImageNode = ASNetworkImageNode()
    
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
        self.avatarNode.preferredFrameSize = CGSize(width: avatarSize, height: avatarSize)
        self.avatarNode.flexGrow = false
        
        let rightVerticalStack = ASStackLayoutSpec(direction: .vertical, spacing: 4, justifyContent: .start, alignItems: .stretch, children: [nameNode, summaryTextNode])
        rightVerticalStack.flexShrink = true
        
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [avatarNode, rightVerticalStack])
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 16, 0, 8), child: mainStack)
        
        return insetSpec
    }
    
    override func fetchData() {
        super.fetchData()
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
    }

}
