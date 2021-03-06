import Foundation
import UIKit
import AsyncDisplayKit
import pop

protocol GuideHeaderCellNodeDelegate {
	func guideHeader_didTapProfile();
}

class GuideHeaderCellNode: ASCellNode, ASNetworkImageNodeDelegate {
    
    let titleNode: ASTextNode = ASTextNode()
    let coverImageUrl: String
    let coverImageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    let avatarUrl: String;
    let avatarSize: CGFloat = 80.0
    let avatarNode: ASNetworkImageNode = ASNetworkImageNode()
	
	public var delegate: GuideHeaderCellNodeDelegate?
	
    init(coverImageUrl: String, attributedText: NSAttributedString, avatarUrl: String) {
        self.avatarUrl = avatarUrl
        self.coverImageUrl = coverImageUrl
        super.init()
        
        titleNode.attributedText = attributedText
        titleNode.maximumNumberOfLines = 2
		
		self.coverImageNode.delegate = self
		
        self.addSubnode(coverImageNode)
        self.addSubnode(avatarNode)
        self.addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.coverImageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 300)
        
        self.avatarNode.style.preferredSize = CGSize(width: avatarSize, height: avatarSize)
        self.avatarNode.style.flexGrow = 0
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1
        
        let verticalStack: ASStackLayoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [spacer, self.avatarNode, titleNode])
        
        let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 32, right: 0), child: verticalStack)
        
        let overlaySpec: ASOverlayLayoutSpec = ASOverlayLayoutSpec(child:self.coverImageNode, overlay: insetSpec)
        
        return overlaySpec
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
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
		self.avatarNode.view.isUserInteractionEnabled = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GuideHeaderCellNode.avatarTapped))
		self.avatarNode.view.addGestureRecognizer(tapGesture)
    }
	
	@objc private func avatarTapped()
	{
		self.delegate?.guideHeader_didTapProfile()
	}
	
	public func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage)
	{
		DispatchQueue.main.async() {
			let imageView = self.coverImageNode.view
			imageView.clipsToBounds = true
			imageView.layer.masksToBounds = true

			let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
			alphaAnimation!.fromValue = 0
			alphaAnimation!.toValue = 1
			alphaAnimation!.duration = 0.8
			
			imageView.pop_add(alphaAnimation, forKey: "alpha")
		}
	}
}
