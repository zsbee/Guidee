import UIKit
import AsyncDisplayKit

protocol FollowsContainerCellNodeDelegate {
    func didTapUser(userInfoModel: UserInfoModel)
}

class FollowsContainerCell: ASCellNode, ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout {
    let models: [UserInfoModel]
    let collectionNode: ASCollectionNode
    
    let elementSize: CGSize = CGSize(width: 150, height: 100)
    
    var delegate:FollowsContainerCellNodeDelegate?
    
    init(models: [UserInfoModel]) {
        self.models = models
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.elementSize
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init()
        
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.addSubnode(self.collectionNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        collectionNode.preferredFrameSize = CGSize(width: constrainedSize.min.width, height: 100)
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
            let node = FollowCellNode(name: NSAttributedString(string: self.models[indexPath.row].name, attributes: TextStyles.getFollowCellNameAttributes()), avatarUrl: self.models[indexPath.row].avatarUrl)
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
        self.delegate?.didTapUser(userInfoModel: model)
    }
}
