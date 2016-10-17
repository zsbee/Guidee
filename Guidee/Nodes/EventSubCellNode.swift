import Foundation
import AsyncDisplayKit

public class EventSubCellNode: ASCellNode {
    let titleTextNode: ASTextNode = ASTextNode()
    let summaryTextNode: ASTextNode = ASTextNode()
    
    public let model: GuideEventDetailModel
    let thirdImage: ASNetworkImageNode = ASNetworkImageNode()
    let secondImage: ASNetworkImageNode = ASNetworkImageNode()
    let firstImage: ASNetworkImageNode = ASNetworkImageNode()
    
    let carouselModels: [CarouselItemModel]
    
    public init(model: GuideEventDetailModel, attributedTitleText: NSAttributedString, attributedSummaryText: NSAttributedString, carouselModels: [CarouselItemModel]) {
        
        self.carouselModels = carouselModels
        self.model = model
        super.init()
        
        titleTextNode.attributedText = attributedTitleText
        
        summaryTextNode.attributedText = attributedSummaryText
        summaryTextNode.maximumNumberOfLines = 2
        summaryTextNode.truncationMode = .byCharWrapping
        
        self.addSubnode(titleTextNode)
        self.addSubnode(summaryTextNode)
        // self.addSubnode(thirdImage)
        // self.addSubnode(secondImage)
        // self.addSubnode(firstImage)
    }
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        //self.thirdImage.preferredFrameSize = CGSize(width: 80, height: 80)
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical,
                                                                 spacing: 0,
                                                                 justifyContent: .start,
                                                                 alignItems: .stretch,
                                                                 children: [self.titleTextNode, self.summaryTextNode, spacer])
        
        //let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16), child: textNode)
        //let overlaySpec: ASOverlayLayoutSpec = ASOverlayLayoutSpec(child:verticalStack, overlay: self.thirdImage)
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: verticalStack)
    }
    
    override public func fetchData() {
        super.fetchData()
        if let url3 = NSURL(string: self.carouselModels[0].imageURL) {
            self.thirdImage.setURL(url3 as URL, resetToDefault: true)
        }
    }
    
    override public func didLoad() {
        super.didLoad()
        self.thirdImage.layer.cornerRadius = 10
        self.thirdImage.layer.masksToBounds = true
        
        self.secondImage.layer.cornerRadius = 10
        self.secondImage.layer.masksToBounds = true
        
        self.firstImage.layer.cornerRadius = 10
        self.firstImage.layer.masksToBounds = true
    }
}
