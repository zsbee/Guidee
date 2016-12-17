import UIKit
import AsyncDisplayKit

protocol JourneyCellContainerNodeDelegate {
    func didTapJourney(journeyModel: GuideBaseModel)
}

class JourneyCellContainerNode: ASCellNode, ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout  {
    let models: [GuideBaseModel]
    let collectionNode: ASCollectionNode
    
    let elementSize: CGSize = CGSize(width: 162, height: 162)
    
    var delegate:JourneyCellContainerNodeDelegate?
    
    init(models: [GuideBaseModel]) {
        self.models = models
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.itemSize = self.elementSize
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init()
        
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.addSubnode(self.collectionNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        collectionNode.style.preferredSize = CGSize(width: constrainedSize.min.width, height: 162)
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
        return UIEdgeInsetsMake(0, 16, 0, 16)
    }
    
    public func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            () -> ASCellNode in
            let node = JourneyCellNode(coverImageUrl: self.models[indexPath.row].coverImageUrl,
                                       title: NSAttributedString(string: self.models[indexPath.row].title, attributes: TextStyles.getJourneyCellTitleAttributes()))
            return node
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.collectionNode.view.showsHorizontalScrollIndicator = false
        self.collectionNode.view.alwaysBounceHorizontal = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        self.delegate?.didTapJourney(journeyModel: model)
    }
}
