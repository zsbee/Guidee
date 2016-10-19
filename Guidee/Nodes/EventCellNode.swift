import UIKit
import AsyncDisplayKit

protocol EventCellNodeDelegate {
    func guideEventTapped(model: GuideEventDetailModel)
}

class EventCellNode: ASCellNode, ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout {
    
    let models: [GuideEventDetailModel]
    let collectionNode: ASCollectionNode
    let delegate: EventCellNodeDelegate
    
    init(models: [GuideEventDetailModel], delegate:EventCellNodeDelegate, detailCellSize: CGSize) {
        self.models = models
        self.delegate = delegate
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = detailCellSize
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init()
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.addSubnode(self.collectionNode)        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        collectionNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height)
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: collectionNode)
    }
    
    // CollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    public func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            () -> ASCellNode in
            let node = EventSubCellNode(model: self.models[indexPath.row], attributedTitleText: NSAttributedString(string: "#\(indexPath.row + 1) Cala Varques", attributes: TextStyles.getEventCellHeaderAttributes()),
                                        attributedSummaryText: NSAttributedString(string: "This magical place takes place 45 minutes from the main road. You can only approach it by foot.", attributes: TextStyles.getEventCellSummaryAttributes()),
                                                                                  carouselModels: [CarouselItemModel(imageURL: "https://i.imgsafe.org/3acbfb7037.jpg")])
            return node
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.guideEventTapped(model: self.models[indexPath.row])
    }
    
    override func didLoad() {
        super.didLoad()
        self.collectionNode.view.showsHorizontalScrollIndicator = false
    }
    
}