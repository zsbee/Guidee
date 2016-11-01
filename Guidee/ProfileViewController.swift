import UIKit
import AsyncDisplayKit

class ProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, JourneyCellContainerNodeDelegate {
    
    var collectionNode: ASCollectionNode!
    
    // Fetched data
    var journeyModels: [GuideBaseModel] = [GuideBaseModel]()
    var userInfoModel:UserInfoModel?

    // Node Insets
    private let sectionFirstCellInset: UIEdgeInsets = UIEdgeInsetsMake(32, 0, 0, 0)
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
        
        // Fetch user Profile
        DataController.sharedInstance.getCurrentUserInfo { (userInfoModel) in
            self.userInfoModel = userInfoModel
            self.collectionNode.view.performBatchUpdates({
                self.collectionNode.view.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexProfileSummary)])
                }, completion: nil)
            
            // Fetch Journeys of User
            DataController.sharedInstance.getJourneysWithFIRids(idArray: self.userInfoModel!.journeyModels, completionBlock: { (journeyModel) in
                self.journeyModels.append(journeyModel)
                self.collectionNode.view.performBatchUpdates({
                    self.collectionNode.view.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexJourneys)])
                    }, completion: nil)
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionNode.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 50)
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
                if let userInfoModel = self.userInfoModel {
                    let node = ProfileCellNode(name: NSAttributedString(string: userInfoModel.name, attributes: TextStyles.getEventCellHeaderAttributes()),
                                           summary: NSAttributedString(string: userInfoModel.summary, attributes: TextStyles.getEventCellSummaryAttributes()),
                                           avatarUrl: userInfoModel.avatarUrl)
                    return node
                }
                else {
                    return ASCellNode()
                }
                
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

