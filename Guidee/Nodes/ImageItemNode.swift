import Foundation
import AsyncDisplayKit
import youtube_ios_player_helper

class ImageItemNode: ASCellNode {
    let model: CarouselItemModel
    
    let placeholderImages = ["placeholderPastel","placeholderBlue","placeholderYellow","placeholderPink", "placeholderGreen"]
    
    let cornerClipImage: ASImageNode = ASImageNode()
    
    let mainImage: ASNetworkImageNode = ASNetworkImageNode()
    let videoNode: ASDisplayNode
    let youtubePlayerView = YTPlayerView()
    
    var isVideo:Bool = false
    
    init(model: CarouselItemModel) {
        self.model = model
        self.videoNode = ASDisplayNode(viewBlock: { () -> UIView in
            let player = YTPlayerView()
            if let youtubeID = model.videoID {
                player.load(withVideoId: youtubeID)
                player.frame = CGRect(x: 0, y: 0, width: 162, height: 162)
                player.backgroundColor = UIColor.black
                return player
            }
            return UIView()
        })
        super.init()
        
        if(model.videoID != nil) {
            self.isVideo = true
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(placeholderImages.count)))
        
        self.mainImage.preferredFrameSize = CGSize(width: 162, height: 162)
        self.mainImage.defaultImage = UIImage(named: self.placeholderImages[randomIndex])
        self.cornerClipImage.preferredFrameSize = CGSize(width: 162, height: 162)
        
        if self.isVideo {
            self.addSubnode(videoNode)
        } else {
            self.addSubnode(mainImage)
        }
        self.addSubnode(cornerClipImage)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var overlaySpec: ASOverlayLayoutSpec
        if(self.isVideo) {
            overlaySpec = ASOverlayLayoutSpec(child:self.videoNode, overlay: self.cornerClipImage)
        }
        else {
            overlaySpec = ASOverlayLayoutSpec(child:self.mainImage, overlay: self.cornerClipImage)
        }
        return overlaySpec
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        if let imageUrlString = self.model.imageURL {
            if let url = NSURL(string: imageUrlString) {
                self.mainImage.setURL(url as URL, resetToDefault: true)
            }
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.mainImage.layer.cornerRadius = 10
        self.mainImage.layer.masksToBounds = true
        
        self.videoNode.layer.cornerRadius = 10
        self.videoNode.layer.masksToBounds = true
    }
    
}
    
