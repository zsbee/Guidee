import UIKit
import AsyncDisplayKit

class CommentCellNode: ASCellNode {
    let avatarNode: ASNetworkImageNode = ASNetworkImageNode()
    let nameTextNode: ASTextNode = ASTextNode()
    let commentTextNode: ASTextNode = ASTextNode()

    let model: CommentModel
    
    init(model: CommentModel) {
        self.model = model
        super.init()
        
        nameTextNode.attributedText = NSAttributedString(string: model.authorName, attributes: TextStyles.getEventCellHeaderAttributes())
        nameTextNode.maximumNumberOfLines = 1
        nameTextNode.truncationMode = .byTruncatingTail
        
        commentTextNode.attributedText = NSAttributedString(string: model.comment, attributes: TextStyles.getEventCellSummaryAttributes())
        commentTextNode.maximumNumberOfLines = 2
        commentTextNode.truncationMode = .byWordWrapping
        
        self.addSubnode(avatarNode)
        self.addSubnode(nameTextNode)
        self.addSubnode(commentTextNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        self.avatarNode.preferredFrameSize = CGSize(width: 80, height:80)
        
        self.commentTextNode.flexShrink = true
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical,
                                                                 spacing: 0,
                                                                 justifyContent: .spaceAround,
                                                                 alignItems: .stretch,
                                                                 children: [self.nameTextNode, self.commentTextNode, spacer])
        verticalStack.flexShrink = true
        
        let horizontalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .horizontal,
                                                                   spacing: 8,
                                                                   justifyContent: .spaceAround,
                                                                   alignItems: .center,
                                                                   children: [self.avatarNode, verticalStack])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16), child: horizontalStack)
    }
    
    override func fetchData() {
        super.fetchData()
        if let url = NSURL(string: self.model.avatarUrl) {
            self.avatarNode.setURL(url as URL, resetToDefault: true)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.avatarNode.layer.cornerRadius = 40
        self.avatarNode.layer.masksToBounds = true
    }

}
