import Foundation
import AsyncDisplayKit

public class EventSubCellNode: ASCellNode {
    let titleTextNode: ASTextNode = ASTextNode()
    let summaryTextNode: ASTextNode = ASTextNode()
    
    public let model: GuideEventDetailModel
    let imageNode: ASNetworkImageNode = ASNetworkImageNode()
    let secondImage: ASNetworkImageNode = ASNetworkImageNode()
    let firstImage: ASNetworkImageNode = ASNetworkImageNode()
    let chevronImage: ASImageNode = ASImageNode()
    
    public init(model: GuideEventDetailModel, attributedTitleText: NSAttributedString, attributedSummaryText: NSAttributedString) {
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
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        self.imageNode.preferredFrameSize = CGSize(width: 80, height:80)
        
        self.summaryTextNode.flexShrink = true
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical,
                                                                 spacing: 0,
                                                                 justifyContent: .spaceAround,
                                                                 alignItems: .stretch,
                                                                 children: [self.titleTextNode, self.summaryTextNode, spacer])
        verticalStack.flexShrink = true

        let horizontalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .horizontal,
                                                                 spacing: 8,
                                                                 justifyContent: .spaceAround,
                                                                 alignItems: .center,
                                                                 children: [self.imageNode, verticalStack, chevronImage])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16), child: horizontalStack)
    }
    
    override public func fetchData() {
        super.fetchData()
        if (self.model.carouselModels.count > 0)
        {
            if let url3 = NSURL(string: self.model.carouselModels[0].imageURL) {
                self.imageNode.setURL(url3 as URL, resetToDefault: true)
            }
        }
    }
    
    override public func didLoad() {
        super.didLoad()
        self.imageNode.layer.cornerRadius = 8
        self.imageNode.layer.masksToBounds = true
    }
}
