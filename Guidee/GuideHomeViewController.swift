import UIKit
import AsyncDisplayKit

class GuideHomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, GuideHeaderViewDelegate, EventCellNodeDelegate {

    let headerView: GuideHeaderView = GuideHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    public var models: [GuideBaseModel] = []
    var collectionNode: ASCollectionNode!

    // Node map
    private let sectionIndexHeader: Int = 0
    private let sectionIndexSummaryHeader: Int = 1
    private let sectionIndexSummary: Int = 2
    private let sectionIndexDetailsHeader: Int = 3
    private let sectionIndexDetails = 4
    
    private var eventNodeSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        
        self.headerView.delegate = self
        
        eventNodeSize = CGSize(width: self.view.frame.width, height: 92)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubnode(collectionNode)
        self.view.addSubview(headerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case self.sectionIndexHeader:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case self.sectionIndexSummaryHeader:
            return UIEdgeInsetsMake(16, 0, 0, 0)
        case self.sectionIndexSummary:
            return UIEdgeInsetsMake(16, 0, 0, 0)
        case self.sectionIndexDetailsHeader:
            return UIEdgeInsetsMake(16, 0, 0, 0)
        case self.sectionIndexDetails:
            return UIEdgeInsetsMake(16, 0, 32, 0)
        default:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    public func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            () -> ASCellNode in
            switch indexPath.section {
            case self.sectionIndexHeader:
                let node = GuideHeaderCellNode(coverImageUrl: "https://i.imgsafe.org/545a735254.jpg", attributedText: NSAttributedString(string: "Coast visits in Mallorca", attributes: TextStyles.getCenteredTitleAttirbutes()), avatarUrl: "https://s9.postimg.org/dcvk1ggy7/avatar2.jpg")
                return node
            case self.sectionIndexSummaryHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Summary", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexSummary:
                let node = GuideSummaryTextNode(attributedText: NSAttributedString(string: self.getMockedSummaryText() , attributes: TextStyles.getSummaryTextFontAttributes()))
                return node
            case self.sectionIndexDetailsHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Places", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexDetails:
                return EventCellNode(models: self.getMockedModels(),delegate: self, detailCellSize: self.eventNodeSize)
            default:
                return ASCellNode()
            }
        }
    }

    public func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right;
        
        if(indexPath.section == sectionIndexDetails) {
            let numberOfItems = self.getMockedModels().count
            let nodeHeight = CGFloat(numberOfItems) * self.eventNodeSize.height
            return ASSizeRangeMake(CGSize(width: self.eventNodeSize.width, height: nodeHeight), CGSize(width: self.eventNodeSize.width, height: nodeHeight))
        }
        
        return ASSizeRangeMake(CGSize(width: width, height:0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    // Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        self.collectionNode.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
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

    private func getMockedModels() -> [GuideEventDetailModel] {
        var models = [GuideEventDetailModel]()
        
        models.append(GuideEventDetailModel(title: "Cala Varques",
                                            summary: "This magical coast outside of civilization can be found 35 minutes walk time from the main road. You can't go to the beach with Car or Bicycle",
                                            carouselModels: [CarouselItemModel(imageURL:"https://i.imgsafe.org/3acbfb7037.jpg")]))
        models.append(GuideEventDetailModel(title: "Cala Pala",
                                            summary: "This is a boring coast...",
                                            carouselModels: [CarouselItemModel(imageURL:"https://i.imgsafe.org/3acc54103f.jpg")]))

        
        return models
    }

    internal func guideEventTapped(model: GuideEventDetailModel) {
        let vc = GuideEventDetailsViewController()
        self.present(vc, animated: true, completion:nil)
    }
    
}
