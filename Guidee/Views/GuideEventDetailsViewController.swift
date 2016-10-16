import UIKit
import AsyncDisplayKit

class GuideEventDetailsViewController: UIViewController, GuideEventHeaderViewDelegate, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource {

    let headerView: GuideEventHeaderView = GuideEventHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var collectionNode: ASCollectionNode!
    private let sectionHeaderInset: UIEdgeInsets = UIEdgeInsetsMake(32, 0, 0, 0)
    private let sectionContentInset: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0)

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
            case self.sectionIndexSummaryHeader:
                return self.sectionHeaderInset
            case self.sectionIndexCarouselHeader:
                return self.sectionHeaderInset
            default:
                return self.sectionContentInset
        }
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
            switch indexPath.section {
                case self.sectionIndexSummaryHeader:
                    let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Summary", attributes: TextStyles.getHeaderFontAttributes()))
                    return node
                case self.sectionIndexSummary:
                    let node = GuideEventSummaryTextNode(attributedText: NSAttributedString(string: self.getMockedSummaryText(), attributes: TextStyles.getSummaryTextFontAttributes()))
                    return node
                case self.sectionIndexAdvert:
                    let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Images", attributes: TextStyles.getHeaderFontAttributes()))
                    return node
                case self.sectionIndexCarouselHeader:
                    return ASCellNode()
                case self.sectionIndexCarousel:
                    return ASCellNode()
                default:
                    return ASCellNode()
            }
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
    
    // Mocked data
    private func getMockedSummaryText() -> String {
        return "South from Érd, a loess wall forms a natural border between Százhalombatta (B/6) and Érd. The huge chimneys of Dunamenti Power Plant and the tanks, pipes and burning gas torches of the oil refi nery may not seem particularly attractive for tourists, but you would regret not visiting the city of the “hundred piles”. The history of the city (named after the 100 ancient piles from the times of the Hallstatt culture) is presented in the Matrica Museum, whose name in turn refers to the Roman name of the settlement."
    }
    
}
