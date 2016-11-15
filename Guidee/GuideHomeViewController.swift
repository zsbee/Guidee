import UIKit
import AsyncDisplayKit

class GuideHomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, GuideHeaderViewDelegate, EventCellNodeDelegate, ActionCellNodeDelegate, EditTextViewControllerDelegate {


    var baseModel: GuideBaseModel!
    var comments: [CommentModel]!
    var currentUser: UserInfoModel?
    
    let headerView: GuideHeaderView = GuideHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var collectionNode: ASCollectionNode!
    
    // Node map
    private let sectionIndexHeader: Int = 0
    private let sectionIndexSummaryHeader: Int = 1
    private let sectionIndexSummary: Int = 2
    private let sectionIndexDetailsHeader: Int = 3
    private let sectionIndexDetails = 4
    private let sectionIndexComments: Int = 5
    private let sectionIndexCommentsAction = 6
    
    private var eventNodeSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        
        self.headerView.delegate = self
        
        self.comments = [CommentModel]()
        
        eventNodeSize = CGSize(width: self.view.frame.width, height: 92)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubnode(collectionNode)
        self.view.addSubview(headerView)
        
        DataController.sharedInstance.getCurrentUserInfo(completionBlock: { (userModel) in
            self.currentUser = userModel
        })
        
        self.loadComments()
    }

    func loadComments() {
        DataController.sharedInstance.getCommentsForJourneyWithId(journeyID: self.baseModel.firebaseID, completionBlock: { (comments) in
            self.comments = comments

            if self.comments.count > 0 {
                self.collectionNode.view.reloadSections(IndexSet(integer: self.sectionIndexComments))
            }
        })
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case self.sectionIndexComments:
            var numberOfItems = 0
            if(self.comments.count > 0) {
                numberOfItems = 1 + self.comments.count // Header + comments
            } else {
                numberOfItems = 2 //Header + Placeholder
            }
            return numberOfItems
        default:
            return 1
        }
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
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
            return UIEdgeInsetsMake(16, 0, 0, 0)
        case self.sectionIndexComments:
            return UIEdgeInsetsMake(16, 0, 0, 0)
        case self.sectionIndexCommentsAction:
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
                let node = GuideHeaderCellNode(coverImageUrl: self.baseModel.coverImageUrl, attributedText: NSAttributedString(string: self.baseModel.title, attributes: TextStyles.getCenteredTitleAttirbutes()), avatarUrl: self.baseModel.userAvatarUrl)
                return node
            case self.sectionIndexSummaryHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Summary", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexSummary:
                let node = GuideSummaryTextNode(attributedText: NSAttributedString(string: self.baseModel.summary , attributes: TextStyles.getSummaryTextFontAttributes()))
                return node
            case self.sectionIndexDetailsHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Highlights", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexDetails:
                return EventCellNode(models: self.baseModel.eventModels,delegate: self, detailCellSize: self.eventNodeSize)
            case self.sectionIndexComments:
                var node: ASCellNode = ASCellNode()
                if(indexPath.row == 0)
                {
                    node = SectionHeaderNode(attributedText: NSAttributedString(string: "Comments", attributes: TextStyles.getHeaderFontAttributes()))
                }
                else
                {
                    if (self.comments.count > 0) {

                        node = CommentCellNode(model: self.comments[indexPath.row - 1])
                    }
                    else {
                        node = PlaceholderNode()
                    }
                }
                return node
            case self.sectionIndexCommentsAction:
                let node = ActionCellNode(actionStringNormal: NSAttributedString(string: "Add comment", attributes: TextStyles.getActionNormalStateCellAttributes()),
                                          actionStringHighlighted: NSAttributedString(string: "Add comment", attributes: TextStyles.getActionHighlightedStateCellAttributes()),
                                          delegate: self)

                return node
            default:
                return ASCellNode()
            }
        }
    }

    public func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right;
        
        if(indexPath.section == sectionIndexDetails) {
            let numberOfItems = self.baseModel.eventModels.count
            let nodeHeight = CGFloat(numberOfItems) * self.eventNodeSize.height
            return ASSizeRangeMake(CGSize(width: self.eventNodeSize.width, height: nodeHeight), CGSize(width: self.eventNodeSize.width, height: nodeHeight))
        }
        
        return ASSizeRangeMake(CGSize(width: width, height:0), CGSize(width: width, height: 1000))
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
    
    internal func guideEventTapped(model: GuideEventDetailModel, atIndex: Int) {
        let vc = GuideEventDetailsViewController()
        vc.model = model
        self.present(vc, animated: true, completion:nil)
    }
    
    
    // Comments
    internal func actionButtonTappedWithString(string: String) {
        let vc = EditTextViewController()
        vc.delegate = self
        vc.viewModel = EditTextSetupViewModel(title: "Add comment", sectionIndex: self.sectionIndexCommentsAction, placeHolder: "Write a comment", text: "")
        self.present(vc, animated: true, completion:nil)
    }

    func editTextViewController_saveTappedWithString(string: String, sectionIndex: Int) {
        DataController.sharedInstance.uploadCommentToFirebase(guideFirebaseID: self.baseModel.firebaseID, comment: string)
        self.loadComments()
    }
    
}
