import Foundation
import AsyncDisplayKit

class ImageItemNode: ASCellNode {
    let model: CarouselItemModel
    
    let cornerClipImage: ASImageNode = ASImageNode()
    let mainImage: ASNetworkImageNode = ASNetworkImageNode()
    
    init(model: CarouselItemModel) {
        self.model = model
        super.init()
        
        self.mainImage.preferredFrameSize = CGSize(width: 162, height: 162)
        self.cornerClipImage.preferredFrameSize = CGSize(width: 162, height: 162)
                
        self.addSubnode(mainImage)
        self.addSubnode(cornerClipImage)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageWithCornerClipSpec: ASOverlayLayoutSpec = ASOverlayLayoutSpec(child:self.mainImage, overlay: self.cornerClipImage)
        
        return imageWithCornerClipSpec
    }
    
    override func fetchData() {
        super.fetchData()
        if let url = NSURL(string: self.model.imageURL) {
            self.mainImage.setURL(url as URL, resetToDefault: true)
        }
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
}
    
