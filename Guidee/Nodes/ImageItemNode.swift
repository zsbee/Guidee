import Foundation
import AsyncDisplayKit
import youtube_ios_player_helper

class ImageItemNode: ASCellNode {
    let model: CarouselItemModel
    
    let placeholderImages = ["placeholderPastel","placeholderBlue","placeholderYellow","placeholderPink", "placeholderGreen"]
    
    let cornerClipImage: ASImageNode = ASImageNode()
    
    let mainImage: ASNetworkImageNode = ASNetworkImageNode()
    let youtubePlayerView = YTPlayerView()
    
    init(model: CarouselItemModel) {
        self.model = model
        super.init()
        
        let randomIndex = Int(arc4random_uniform(UInt32(placeholderImages.count)))
        
        self.mainImage.preferredFrameSize = CGSize(width: 162, height: 162)
        self.mainImage.defaultImage = UIImage(named: self.placeholderImages[randomIndex])
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
        
        if let youtubeID = self.model.videoID {
            self.youtubePlayerView.load(withVideoId: youtubeID)
            self.view.addSubview(youtubePlayerView)
            
            self.youtubePlayerView.frame = CGRect(x: 0, y: 0, width: 162, height: 162)
            self.youtubePlayerView.layer.cornerRadius = 10
            self.youtubePlayerView.layer.masksToBounds = true
        }
    }
    
}
    
