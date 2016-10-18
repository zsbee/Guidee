import Foundation
import UIKit
import AsyncDisplayKit

class GuideHeaderCellNode: ASCellNode {
    
    let titleNode: ASTextNode = ASTextNode()
    let coverImageUrl: String
    let coverImageNode: ASNetworkImageNode = ASNetworkImageNode() //https://postimg.org/image/v4hz35izx/
    
    let avatarUrl: String;
    let avatarSize: CGFloat = 80.0
    let avatarNode: ASNetworkImageNode = ASNetworkImageNode()
    
    init(coverImageUrl: String, attributedText: NSAttributedString, avatarUrl: String) {
        self.avatarUrl = avatarUrl
        self.coverImageUrl = coverImageUrl
        super.init()
        
        titleNode.attributedText = attributedText
        titleNode.maximumNumberOfLines = 3
                
        self.addSubnode(coverImageNode)
        self.addSubnode(avatarNode)
        self.addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.coverImageNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: 300)
        
        self.avatarNode.preferredFrameSize = CGSize(width: avatarSize, height: avatarSize)
        self.avatarNode.flexGrow = false
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [spacer, self.avatarNode, titleNode])
        
        let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 32, right: 0), child: verticalStack)
        
        let overlaySpec: ASOverlayLayoutSpec = ASOverlayLayoutSpec(child:self.coverImageNode, overlay: insetSpec)
        
        return overlaySpec
    }
    
    override func fetchData() {
        super.fetchData()
        if let url = NSURL(string: self.coverImageUrl) {
            self.coverImageNode.setURL(url as URL, resetToDefault: true)
        }
        
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
