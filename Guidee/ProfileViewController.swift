import UIKit
import AsyncDisplayKit

class ProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, JourneyCellContainerNodeDelegate {
    
    var collectionNode: ASCollectionNode!
    
    // Fetched data
    var journeyModels: [GuideBaseModel] = [GuideBaseModel]()
    
    // Node Insets
    private let sectionFirstCellInset: UIEdgeInsets = UIEdgeInsetsMake(64, 0, 0, 0)
    private let sectionHeaderInset: UIEdgeInsets = UIEdgeInsetsMake(16, 0, 0, 0)
    private let sectionContentInset: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0)
    private let sectionLastCellInset: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 32, 0)
    
    // Node map
    private let sectionIndexProfileSummaryHeader: Int = 0
    private let sectionIndexProfileSummary: Int = 1
    private let sectionIndexJourneysHeader: Int = 2
    private let sectionIndexJourneys: Int = 3
    private let sectionIndexPlansHeader: Int = 4
    private let sectionIndexPlans: Int = 5
    private let sectionIndexLovedHeader: Int = 6
    private let sectionIndexLoved: Int = 7
    private let sectionIndexFollowingHeader: Int = 8
    private let sectionIndexFollowing: Int = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionNode = ASCollectionNode(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.backgroundColor = UIColor.clear
        
        self.view.addSubnode(collectionNode)
        
        // Fetch data
        DataController.sharedInstance.getJourneys { (model) in
            self.journeyModels.append(model)
            self.collectionNode.view.performBatchUpdates({ 
                self.collectionNode.view.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexJourneys)])
                }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionNode.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 50)
    }

    //MARK - Collection Node
    // CollectionNode
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case self.sectionIndexProfileSummaryHeader:
            return self.sectionFirstCellInset
        default:
            return self.sectionContentInset
        }
    }
    
    public func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right;
        
        return ASSizeRangeMake(CGSize(width: width, height:0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    public func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            () -> ASCellNode in
            
            switch indexPath.section {
            
            case self.sectionIndexProfileSummaryHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Profile", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexProfileSummary:
                let node = ProfileCellNode(name: NSAttributedString(string: "Fuszenecker Zsombor", attributes: TextStyles.getEventCellHeaderAttributes()),
                                           summary: NSAttributedString(string: "Lorem Ipsum Dolor Sit HANDSHAKE_COMPLETE, reason: nw_connection event, should deliver:  Zsombor, Amiens Strike at karkand", attributes: TextStyles.getEventCellSummaryAttributes()),
                                           avatarUrl: "https://s9.postimg.org/dcvk1ggy7/avatar2.jpg")
                return node
            case self.sectionIndexJourneys:
                let node = JourneyCellContainerNode(models: self.journeyModels)
                node.delegate = self
                return node
            
            case self.sectionIndexJourneysHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "My Journeys", attributes: TextStyles.getHeaderFontAttributes()))
                return node
                
            case self.sectionIndexPlansHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "My Plans", attributes: TextStyles.getHeaderFontAttributes()))
                return node
                
            case self.sectionIndexLovedHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "My ❤️", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            
            case self.sectionIndexFollowingHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Following", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            default:
                return ASCellNode()
            }
        }
    }
    
    func didTapJourney(journeyModel: GuideBaseModel) {
        let vc = GuideHomeViewController()
        vc.baseModel = journeyModel
        
        self.present(vc, animated: true, completion:nil)
    }
    
    
}

