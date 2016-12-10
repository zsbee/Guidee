import Foundation
import AsyncDisplayKit

class EventSubCellNode: ASCellNode {
    let titleTextNode: ASTextNode = ASTextNode()
    let summaryTextNode: ASTextNode = ASTextNode()
    
    let model: GuideEventDetailModel
    let imageNode: ASNetworkImageNode = ASNetworkImageNode()
    let chevronImage: ASImageNode = ASImageNode()
    
    init(model: GuideEventDetailModel, attributedTitleText: NSAttributedString, attributedSummaryText: NSAttributedString) {
        chevronImage.image = UIImage(named: "RightArrow")
        self.model = model
        super.init()
        
        titleTextNode.attributedText = attributedTitleText
        
        summaryTextNode.attributedText = attributedSummaryText
        summaryTextNode.maximumNumberOfLines = 2
        summaryTextNode.truncationMode = .byWordWrapping
        
        self.addSubnode(titleTextNode)
        self.addSubnode(summaryTextNode)
        self.addSubnode(imageNode)
        self.addSubnode(chevronImage)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1
        
        let horizontalSpacer = ASLayoutSpec()
        horizontalSpacer.style.flexGrow = 1
        
        self.imageNode.style.preferredSize = CGSize(width: 80, height:80)
        
        self.summaryTextNode.style.flexShrink = 1
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical,
                                                                 spacing: 0,
                                                                 justifyContent: .spaceAround,
                                                                 alignItems: .stretch,
                                                                 children: [self.titleTextNode, self.summaryTextNode, spacer])
        verticalStack.style.flexShrink = 1

        let horizontalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .horizontal,
                                                                 spacing: 8,
                                                                 justifyContent: .spaceAround,
                                                                 alignItems: .center,
                                                                 children: [self.imageNode, verticalStack, horizontalSpacer, chevronImage])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16), child: horizontalStack)
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        if (self.model.carouselModels.count > 0)
        {
            if let imageUrlString = self.model.carouselModels[0].imageURL {
                if let url3 = NSURL(string: imageUrlString) {
                    self.imageNode.setURL(url3 as URL, resetToDefault: true)
                }
            }
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.imageNode.layer.cornerRadius = 8
        self.imageNode.layer.masksToBounds = true
    }
}
