import UIKit
import AsyncDisplayKit

protocol CommentsCollectionNodeDelegate {
    
}

class CommentsCollectionNode: ASCellNode, ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout {
    
    let placeholderTextNode: ASTextNode
    let models: [CommentModel]
    let collectionNode: ASCollectionNode
    let delegate: CommentsCollectionNodeDelegate
    
    init(models: [CommentModel], delegate:CommentsCollectionNodeDelegate, detailCellSize: CGSize) {
        self.models = models
        self.delegate = delegate
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = detailCellSize
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.placeholderTextNode = ASTextNode()
        placeholderTextNode.attributedText = NSAttributedString(string: "No comments yet, add yours?", attributes: TextStyles.getSummaryTextFontAttributes())
        
        super.init()
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        if (models.count > 0) {
            self.addSubnode(self.collectionNode)
        } else {
            self.addSubnode(self.placeholderTextNode)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetSpec = ASInsetLayoutSpec()
        
        if (models.count > 0) {
            collectionNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height)
            insetSpec.insets = UIEdgeInsetsMake(0, 0, 0, 0)
            insetSpec.setChild(self.collectionNode)
        } else {
            insetSpec.insets = UIEdgeInsetsMake(0, 16, 0, 16)
            insetSpec.setChild(self.placeholderTextNode)
        }
        return insetSpec
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
            let commentModel = self.models[indexPath.row]
            
            let node = CommentCellNode(model: commentModel)
            
            return node
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
}
