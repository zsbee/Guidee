import Foundation
import UIKit
import AsyncDisplayKit

protocol CarouselCellNodeDelegate {
    func carouselCellSelectedWithIndex(index: Int)
	func carouselCellSelectedWithPhoto(selectedIndex: Int, allImages: [ImageItemNode])
}

class CarouselCellNode: ASCellNode, ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout {

    let models: [CarouselItemModel]
    let collectionNode: ASCollectionNode
    
    let elementSize: CGSize = CGSize(width: 162, height: 162)
    
    public var delegate: CarouselCellNodeDelegate?
    
    init(models: [CarouselItemModel]) {
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
            let node = ImageItemNode(model: self.models[indexPath.row])
            return node
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.carouselCellSelectedWithIndex(index: indexPath.row)
		
		var allImages: [ImageItemNode] = []
		for index in 0...self.models.count-1 {
			let iPath = IndexPath(item: index, section: 0)
			let t_imageNode: ImageItemNode = self.collectionNode.nodeForItem(at: iPath) as! ImageItemNode;
			allImages.append(t_imageNode)
		}
		
		self.delegate?.carouselCellSelectedWithPhoto(selectedIndex: indexPath.row, allImages: allImages)
    }
    
    override func didLoad() {
        super.didLoad()
        self.collectionNode.view.showsHorizontalScrollIndicator = false
        self.collectionNode.view.alwaysBounceHorizontal = true
    }
}
