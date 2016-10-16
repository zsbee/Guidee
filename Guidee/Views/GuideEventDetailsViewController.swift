import UIKit
import AsyncDisplayKit

class GuideEventDetailsViewController: UIViewController, GuideEventHeaderViewDelegate, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource {

    let headerView: GuideEventHeaderView = GuideEventHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var collectionNode: ASCollectionNode!
    private let sectionInset: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)

    // Node map
    private let sectionIndexSummaryHeader: Int = 0
    private let sectionIndexSummary: Int = 1
    private let sectionIndexAdvert: Int = 2
    private let sectionIndexCarouselHeader: Int = 3
    private let sectionIndexCarousel: Int = 4

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionNode = ASCollectionNode(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.backgroundColor = UIColor.clear
        
        headerView.delegate = self
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(headerView)
        self.view.addSubnode(collectionNode)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CollectionNode
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right;
        
        return ASSizeRangeMake(CGSize(width: width, height:0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }

    public func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return ASCellNode()
    }
    
    public func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            () -> ASCellNode in
            return ASCellNode()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.headerView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40)
        self.collectionNode.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height-60)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Header
    func header_closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func header_heartButtonTapped() {
        
    }
    
}
