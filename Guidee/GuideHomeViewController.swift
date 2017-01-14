import UIKit
import AsyncDisplayKit
import MBProgressHUD

protocol GuideHomeViewControllerDelegate {
	func reloadJourneyAnnotationForModel(model: GuideBaseModel)
}

class GuideHomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, GuideHeaderViewDelegate, EventCellNodeDelegate, ActionCellNodeDelegate, EditTextViewControllerDelegate, DataListener, JourneyEditorViewControllerDelegate, GuideHeaderCellNodeDelegate {

    var baseModel: GuideBaseModel!
    private var comments: [CommentModel]!
    private var currentUser: UserInfoModel?

	public var delegate: GuideHomeViewControllerDelegate?
	
    private let headerView: GuideHeaderView = GuideHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private var collectionNode: ASCollectionNode!
	
	private var hud: MBProgressHUD?
	
    // Node map
    private let sectionIndexHeader: Int = 0
    private let sectionIndexSummaryHeader: Int = 1
    private let sectionIndexSummary: Int = 2
    private let sectionIndexDetailsHeader: Int = 3
    private let sectionIndexDetails = 4
	private let sectionIndexMapHeader: Int = 5
	private let sectionIndexMap = 6
    private let sectionIndexComments: Int = 7
    private let sectionIndexCommentsAction = 8
    
    private var eventNodeSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.currentUser = DataController.sharedInstance.getCurrentUserModel()

        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        
        self.headerView.delegate = self
		
        self.headerView.setIsEditEnabled(editingMode: self.userOwnsJourney())
        self.comments = [CommentModel]()
        
        eventNodeSize = CGSize(width: self.view.frame.width, height: 92)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubnode(collectionNode)
        self.view.addSubview(headerView)
		
		self.headerView.updateIconIsLoved(isLoved: self.hasUserLikedJourney())
		DataController.sharedInstance.addListener(listener: self, type: .love)
        
        self.loadComments()
    }

    func loadComments() {
        DataController.sharedInstance.getCommentsForJourneyWithId(journeyID: self.baseModel.firebaseID, completionBlock: { (comments) in
            self.comments = comments

            if self.comments.count > 0 {
                self.collectionNode.reloadSections(IndexSet(integer: self.sectionIndexComments))
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
        return 9
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
		case self.sectionIndexMapHeader:
			return UIEdgeInsetsMake(16, 0, 0, 0)
		case self.sectionIndexMap:
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
				node.delegate = self
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
			case self.sectionIndexMap:
				let coordinates = self.baseModel.eventModels.map({ (eventModel) -> CLLocationCoordinate2D in
					return eventModel.coordinates
				})
				
				let node = StaticMapCellNode(mapCenterCoordinate: self.baseModel.annotationModel.coordinate ,annotations: coordinates)
				return node
			case self.sectionIndexMapHeader:
				let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Map", attributes: TextStyles.getHeaderFontAttributes()))
				return node
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
	
	func guideHeader_didTapProfile() {
		print("na van userunk modelban?")
	}
	
    // Header
    func header_closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
	
	func header_editButtonTapped() {
		let vc = JourneyEditorViewController()
		vc.mapCenter = self.baseModel.annotationModel.coordinate
		vc.delegate = self
		vc.baseModel = self.getEditableBaseModel()
		self.present(vc, animated: true, completion:nil)
	}
	
	func getEditableBaseModel() -> GuideBaseModel {
		let mutableModel = self.baseModel.mutableObject()
		
		// append all events with a carousel placeholder image
		var newEventModels:[GuideEventDetailModel] = [GuideEventDetailModel]()
		let carouselPlaceholderImage: CarouselItemModel = CarouselItemModel(imageURL: "https://i.imgsafe.org/ba06372e4d.png", videoId: nil)
		for eventModel in mutableModel.eventModels {
			let mutableEventModel = eventModel.mutableObject()
			mutableEventModel.carouselModels.append(carouselPlaceholderImage)
			newEventModels.append(mutableEventModel.copy())
		}
		
		// append events with 1 more
		let placeholderEventModel = GuideEventDetailModel(title: "Add new spot",
		                                                  summary: "➕ Tap to add a spot, select an image, and set a summary",
		                                                  carouselModels: [carouselPlaceholderImage],
		                                                  coordinates: mutableModel.annotationModel.coordinate)
		
		newEventModels.insert(placeholderEventModel, at: 0)
		
		return GuideBaseModel(identifier: self.baseModel.identifier, firebaseID: self.baseModel.firebaseID, title: mutableModel.title, summary: mutableModel.summary, coverImageUrl: mutableModel.coverImageUrl, userAvatarUrl: mutableModel.userAvatarUrl, eventModels: newEventModels, annotationModel: mutableModel.annotationModel, userIdentifier: self.baseModel.userID)
	}
	
	func didFinishUploadingToDatabase()
	{
		self.delegate?.reloadJourneyAnnotationForModel(model: self.baseModel)
		self.dismiss(animated: true)
	}

    func header_heartButtonTapped() {
		let isLiked = self.hasUserLikedJourney()
		DataController.sharedInstance.likeJourneyWithId(key: self.baseModel.firebaseID)
		
		let heartIconButton = UIButton(type: .custom)
		
		if (isLiked) {
			heartIconButton.setImage(UIImage(named: "HeartStroke"), for: .normal)
			self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
			hud!.mode = .customView
			hud!.customView = heartIconButton
			hud!.label.text = "Removed from your favourites"
			self.headerView.updateIconIsLoved(isLoved: false)
		} else {
			heartIconButton.setImage(UIImage(named: "HeartFill"), for: .normal)
			self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
			hud!.mode = .customView
			hud!.customView = heartIconButton
			hud!.label.text = "Added to your favourites"
			self.headerView.updateIconIsLoved(isLoved: true)
		}
		
    }
	
	internal func dc_journeyModelsDidUpdate() {
		// 
	}
	
	func dc_loveModelsDidUpdate() {
		DataController.sharedInstance.getCurrentUserInfo(completionBlock: { (userModel) in
			self.currentUser = userModel
			self.headerView.updateIconIsLoved(isLoved: self.hasUserLikedJourney())
			self.hud?.hide(animated: true, afterDelay: 1);
		})
	}
	
	func hasUserLikedJourney() -> Bool {
		let liked = self.currentUser?.loveModels.contains(self.baseModel.firebaseID) ?? false
		return liked
	}
	
	func userOwnsJourney() -> Bool {
		let owned = self.currentUser?.journeyModels.contains(self.baseModel.firebaseID) ?? false
		return owned
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
