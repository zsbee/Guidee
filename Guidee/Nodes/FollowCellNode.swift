import UIKit
import AsyncDisplayKit

class FollowCellNode: ASCellNode {
    let userNameNode: ASTextNode = ASTextNode()
    let avatarNode: ASNetworkImageNode = ASNetworkImageNode()
    
    let avatarUrl: String;
    let avatarSize: CGFloat = 60.0
    
    init(name: NSAttributedString, avatarUrl: String) {
        self.avatarUrl = avatarUrl

        super.init()
        
        userNameNode.attributedText = name
        userNameNode.maximumNumberOfLines = 1
        userNameNode.truncationMode = .byTruncatingTail

        self.addSubnode(avatarNode)
        self.addSubnode(userNameNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.avatarNode.preferredFrameSize = CGSize(width: avatarSize, height: avatarSize)
        self.avatarNode.flexGrow = false
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [self.avatarNode, self.userNameNode])
        
        return verticalStack
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
