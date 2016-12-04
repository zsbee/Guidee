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
        //commentTextNode.maximumNumberOfLines = 2
        //commentTextNode.truncationMode = .byWordWrapping
        
        self.addSubnode(avatarNode)
        self.addSubnode(nameTextNode)
        self.addSubnode(commentTextNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1
        
        self.avatarNode.style.preferredSize = CGSize(width: 60, height:60)
        
        self.commentTextNode.style.flexShrink = 1
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical,
                                                                 spacing: 0,
                                                                 justifyContent: .spaceAround,
                                                                 alignItems: .stretch,
                                                                 children: [self.nameTextNode, self.commentTextNode, spacer])
        verticalStack.style.flexShrink = 1
        
        let horizontalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .horizontal,
                                                                   spacing: 8,
                                                                   justifyContent: .start,
                                                                   alignItems: .start,
                                                                   children: [self.avatarNode, verticalStack])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16), child: horizontalStack)
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        if let url = NSURL(string: self.model.avatarUrl) {
            self.avatarNode.setURL(url as URL, resetToDefault: true)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.avatarNode.layer.cornerRadius = 30
        self.avatarNode.layer.masksToBounds = true
    }

}
