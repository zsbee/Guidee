import UIKit
import AsyncDisplayKit

class GuideEventDetailsViewController: UIViewController, GuideEventHeaderViewDelegate, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource {

    let headerView: GuideEventHeaderView = GuideEventHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var collectionNode: ASCollectionNode!
    var faderImage: UIImageView!
    
    public var model: GuideEventDetailModel? {
        didSet {
            headerView.setTitle(title: self.model!.title)
        }
    }
    
    private let sectionFirstCellInset: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 16, 0)
    private let sectionHeaderInset: UIEdgeInsets = UIEdgeInsetsMake(16, 0, 0, 0)
    private let sectionContentInset: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0)
    private let sectionLastCellInset: UIEdgeInsets = UIEdgeInsetsMake(16, 0, 32, 0)

    // Node map
    private let sectionIndexSummaryHeader: Int = 0
    private let sectionIndexSummary: Int = 1
    private let sectionIndexCarouselHeader: Int = 2
    private let sectionIndexCarousel: Int = 3
    private let sectionIndexMapHeader: Int = 4
    private let sectionIndexMap: Int = 5
    private let sectionIndexAdvert: Int = 6

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.faderImage = UIImageView(image: UIImage(named: "fader"))
        
        self.collectionNode = ASCollectionNode(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.backgroundColor = UIColor.clear

        headerView.delegate = self
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(headerView)
        self.view.addSubnode(collectionNode)
        self.view.addSubview(self.faderImage)
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
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
            case self.sectionIndexSummaryHeader:
                return self.sectionFirstCellInset
            case self.sectionIndexCarouselHeader:
                return self.sectionHeaderInset
            case self.sectionIndexCarousel:
                return self.sectionLastCellInset
            default:
                return self.sectionContentInset
        }
    }
    
    public func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        print("constraintSizeForNode \(indexPath.section)")
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right;
        if (indexPath.section == sectionIndexCarouselHeader) {
            return ASSizeRangeMake(CGSize(width: width, height:0), CGSize(width: width, height: 162))
        }
        if (indexPath.section == sectionIndexCarousel) {
            return ASSizeRangeMake(CGSize(width: collectionView.bounds.width - collectionView.contentInset.left, height:162), CGSize(width: CGFloat.greatestFiniteMagnitude, height: 162))
        }
        if (indexPath.section == sectionIndexAdvert) {
            return ASSizeRangeMake(CGSize(width: collectionView.bounds.width, height:250), CGSize(width: collectionView.bounds.width, height:250))
        }
        return ASSizeRangeMake(CGSize(width: width, height:0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }

    public func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            () -> ASCellNode in
            
            print("nodeBlock \(indexPath.section)")
            switch indexPath.section {
                case self.sectionIndexSummaryHeader:
                    let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Summary", attributes: TextStyles.getHeaderFontAttributes()))
                    return node
                case self.sectionIndexSummary:
                    let node = GuideEventSummaryTextNode(attributedText: NSAttributedString(string: self.model!.summary, attributes: TextStyles.getSummaryTextFontAttributes()))
                    return node

                case self.sectionIndexCarouselHeader:
                    let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Images/Videos", attributes: TextStyles.getHeaderFontAttributes()))
                    return node
                case self.sectionIndexCarousel:
                    let node = CarouselCellNode(models: self.model!.carouselModels)
                    return node
                case self.sectionIndexMapHeader:
                    let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Map", attributes: TextStyles.getHeaderFontAttributes()))
                    return node
                case self.sectionIndexMap:
                    let node = CarouselCellNode(models: self.model!.carouselModels)
                    return ASCellNode()
                    
                case self.sectionIndexAdvert:
                    let node = AdvertNode()
                    node.preferredFrameSize = CGSize(width: 375, height: 250)
                    return ASCellNode()
                default:
                    return ASCellNode()
            }
        }
    }
    
    // Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 82)
        self.collectionNode.frame = CGRect(x: 0, y: 82, width: self.view.frame.width, height: self.view.frame.height-82)
        self.faderImage.frame = CGRect(x: 0, y: 82, width: self.view.frame.width, height: 20)
    }
    
    // Header
    func header_closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func header_heartButtonTapped() {
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
   
    override var shouldAutorotate: Bool {
        return false
    }
    
}
