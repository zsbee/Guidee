import UIKit
import AsyncDisplayKit
import Onboard
import Firebase
import FBSDKLoginKit
import MBProgressHUD

class OtherProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, ProfileHeaderViewDelegate , JourneyCellContainerNodeDelegate, FollowsContainerCellNodeDelegate, JourneyEditorViewControllerDelegate, ProfileCellNodeDelegate, DataListener, UIViewControllerTransitioningDelegate {
	
	var collectionNode: ASCollectionNode!
	var hud: MBProgressHUD!
	let transition = PopAnimator()
	
	// Fetched data
	var userInfoModel:UserInfoModel?
	public var userId: String!
	var journeyModels: [GuideBaseModel] = [GuideBaseModel]()
	var planModels: [GuideBaseModel] = [GuideBaseModel]()
	var loveModels: [GuideBaseModel] = [GuideBaseModel]()
	var followModels: [UserInfoModel] = [UserInfoModel]()
	
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
	
	private let headerView: ProfileHeaderView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.headerView.delegate = self

		self.collectionNode = ASCollectionNode(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
		self.collectionNode.delegate = self
		self.collectionNode.dataSource = self
		self.collectionNode.backgroundColor = UIColor.clear
		
		self.view.addSubnode(collectionNode)
		DataController.sharedInstance.addListener(listener: self, type: .follow)
		
		self.view.backgroundColor = UIColor.white
		
		self.view.addSubview(headerView)
		self.headerView.updateIconisFollowed(isFollowed: self.isUserFollowingUser());
		
		self.fetchUserData()
	}
	
	func fetchUserData() {
		// clear all data
		self.journeyModels = []
		self.followModels = []
		self.planModels = []
		self.loveModels = []
		
		// Fetch user Profile
		DataController.sharedInstance.getUsersWithFIRids(idArray: [self.userId]) { (userInfoModel) in
			self.userInfoModel = userInfoModel
			self.collectionNode.performBatchUpdates({
				self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexProfileSummary)])
			}, completion: nil)
			
			// Fetch Own Journeys 📝 of User
			if(self.userInfoModel!.hasJourneys) {
				DataController.sharedInstance.getJourneysWithFIRids(idArray: self.userInfoModel!.journeyModels, completionBlock: { (journeyModel) in
					self.journeyModels.append(journeyModel)
					self.collectionNode.performBatchUpdates({
						self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexJourneys)])
					}, completion: nil)
				})
			} else {
				// load placeholder
				self.collectionNode.performBatchUpdates({
					self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexJourneys)])
				}, completion: nil)
			}
			
			// Fetch Plans ✈️ of User
			if(self.userInfoModel!.hasPlans) {
				DataController.sharedInstance.getJourneysWithFIRids(idArray: self.userInfoModel!.planModels, completionBlock: { (journeyModel) in
					self.planModels.append(journeyModel)
					self.collectionNode.performBatchUpdates({
						self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexPlans)])
					}, completion: nil)
				})
			} else {
				// load placeholder
				self.collectionNode.performBatchUpdates({
					self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexPlans)])
				}, completion: nil)
			}
			
			// Fetch ❤️ of User
			if(self.userInfoModel!.hasLoves) {
				DataController.sharedInstance.getJourneysWithFIRids(idArray: self.userInfoModel!.loveModels, completionBlock: { (journeyModel) in
					self.loveModels.append(journeyModel)
					self.collectionNode.performBatchUpdates({
						self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexLoved)])
					}, completion: nil)
				})
			} else {
				// load placeholder
				self.collectionNode.performBatchUpdates({
					self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexLoved)])
				}, completion: nil)
			}
			
			// Fetch follows
			if(self.userInfoModel!.hasFollowing) {
				DataController.sharedInstance.getUsersWithFIRids(idArray: userInfoModel.following, completionBlock: { (followedUsedModel) in
					self.followModels.append(followedUsedModel)
					self.collectionNode.performBatchUpdates({
						self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexFollowing)])
					}, completion: nil)
				})
			} else {
				// load placeholder
				self.collectionNode.performBatchUpdates({
					self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexFollowing)])
				}, completion: nil)
			}
			
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.collectionNode.frame = CGRect(x: 0, y: 28, width: self.view.frame.width, height: self.view.frame.height - 28)
		self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
	}
	
	func header_followButtonTapped() {
		let isFollowing = self.isUserFollowingUser()
		DataController.sharedInstance.followUserWithId(userId: self.userId)
				
		if (isFollowing) {
			self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
			hud!.mode = .text
			hud!.label.text = "Unfollowed user"
			self.headerView.updateIconisFollowed(isFollowed: false)
		} else {
			self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
			hud!.mode = .customView
			hud!.label.text = "Now following user"
			self.headerView.updateIconisFollowed(isFollowed: true)
		}
		
		self.hud.hide(animated: true, afterDelay: 1)
	}
	
	func header_closeButtonTapped() {
		self.dismiss(animated: true, completion: nil)
	}
	
	//MARK - Collection Node
	// CollectionNode
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case self.sectionIndexJourneys:
			return 1
		case self.sectionIndexPlans:
			return 1
		default:
			return 1
		}
	}
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		switch section {
		case self.sectionIndexProfileSummaryHeader:
			return self.sectionFirstCellInset
		case self.sectionIndexJourneys:
			return UIEdgeInsetsMake(8, 0, 16, 0);
		case self.sectionIndexPlans:
			return UIEdgeInsetsMake(8, 0, 16, 0);
		case self.sectionIndexFollowing:
			return self.sectionLastCellInset
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
					node.delegate = self
					return node
				}
				else {
					return ASCellNode()
				}
				
			case self.sectionIndexJourneysHeader:
				let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Journeys ✈️", attributes: TextStyles.getHeaderFontAttributes()))
				return node
				
			case self.sectionIndexJourneys:
				if(self.journeyModels.count > 0) {
					let node = JourneyCellContainerNode(models: self.journeyModels)
					node.delegate = self
					return node
				} else if (self.userInfoModel == nil) {
					let node = LoadingCellNode()
					node.style.preferredSize = CGSize(width: collectionView.frame.width, height: 162)
					return node
				} else {
					return JourneyPlaceholderCellNode(text: "This user has no journeys yet.")
				}
				
			case self.sectionIndexPlansHeader:
				let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Plans 📝", attributes: TextStyles.getHeaderFontAttributes()))
				return node
				
			case self.sectionIndexPlans:
				if(self.planModels.count > 0) {
					let node = JourneyCellContainerNode(models: self.planModels)
					node.delegate = self
					return node
				} else if (self.userInfoModel == nil) {
					let node = LoadingCellNode()
					node.style.preferredSize = CGSize(width: collectionView.frame.width, height: 162)
					return node
				} else {
					return JourneyPlaceholderCellNode(text: "This user has no plans yet.")
				}
				
			case self.sectionIndexLovedHeader:
				let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Favourites ❤️", attributes: TextStyles.getHeaderFontAttributes()))
				return node
				
			case self.sectionIndexLoved:
				if(self.loveModels.count > 0) {
					let node = JourneyCellContainerNode(models: self.loveModels)
					node.delegate = self
					return node
				} else if (self.userInfoModel == nil) {
					let node = LoadingCellNode()
					node.style.preferredSize = CGSize(width: collectionView.frame.width, height: 162)
					return node
				} else {
					return JourneyPlaceholderCellNode(text: "This user did not like anything yet")
				}
			case self.sectionIndexFollowingHeader:
				let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Following", attributes: TextStyles.getHeaderFontAttributes()))
				return node
				
			case self.sectionIndexFollowing:
				if(self.followModels.count > 0) {
					let node = FollowsContainerCell(models: self.followModels)
					node.delegate = self
					return node
				} else if (self.userInfoModel == nil) {
					let node = LoadingCellNode()
					node.style.preferredSize = CGSize(width: collectionView.frame.width, height: 162)
					return node
				} else {
					return JourneyPlaceholderCellNode(text: "This user does not follow anyone yet!")
				}
				
			default:
				return ASCellNode()
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if(indexPath.section == self.sectionIndexJourneysHeader) {
			openEditor()
		}
	}
	
	func openEditor() {
		let vc = JourneyEditorViewController()
		vc.mapCenter = CLLocationCoordinate2DMake(35.1809143,-73.6917192)
		vc.delegate = self
		self.present(vc, animated: true, completion:nil)
	}
	
	func didFinishUploadingToDatabase() {
		self.journeyModels = [GuideBaseModel]()
		
		// Update user model
		DataController.sharedInstance.getCurrentUserInfo { (userInfoModel) in
			self.userInfoModel = userInfoModel
			// Fetch Own Journeys 📝 of User
			DataController.sharedInstance.getJourneysWithFIRids(idArray: self.userInfoModel!.journeyModels, completionBlock: { (journeyModel) in
				self.journeyModels.append(journeyModel)
				self.collectionNode.performBatchUpdates({
					self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: self.sectionIndexJourneys)])
				}, completion: nil)
			})
		}
	}
	
	func didTapJourney(journeyModel: GuideBaseModel) {
		let vc = GuideHomeViewController()
		vc.baseModel = journeyModel
		vc.transitioningDelegate = self
		self.present(vc, animated: true, completion:nil)
	}
	
	func didTapUser(userInfoModel: UserInfoModel) {
		let profileVC = OtherProfileViewController()
		profileVC.userId = userInfoModel.identifier
		self.present(profileVC, animated: true, completion: nil)
	}
	
	func profileCellNode_tapped() {
		// show actionsheet/alertcontroller
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let changeIntroAction = UIAlertAction(title: "Change introduction", style: .default) { (_) in
			
		}
		let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { (_) in
			let firebaseAuth = FIRAuth.auth()
			do {
				try firebaseAuth?.signOut()
				
				FBSDKLoginManager().logOut()
				
				// Video
				let bundle = Bundle.main
				let moviePath = bundle.path(forResource: "OnboardingVid", ofType: "mp4")
				let movieURL = NSURL(fileURLWithPath: moviePath!)
				
				// User is logged in, do work such as go to next view controller.
				let loginVC = LoginViewController()
				let onboardingVC: OnboardingViewController! = OnboardingViewController(backgroundVideoURL: movieURL as URL!, contents: [loginVC])
				self.present(onboardingVC, animated: false, completion: nil)
			} catch let signOutError as NSError {
				print ("Error signing out: %@", signOutError)
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
		
		alertController.addAction(changeIntroAction)
		alertController.addAction(logOutAction)
		alertController.addAction(cancelAction)
		
		let headerNode = self.collectionNode.nodeForItem(at: IndexPath(item: 0, section: self.sectionIndexProfileSummary))
		alertController.popoverPresentationController?.sourceView = self.view
		alertController.popoverPresentationController?.sourceRect = headerNode?.view.bounds ?? self.view.bounds
		
		self.present(alertController, animated: true, completion: {
			//
		})
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.presenting = false
		return transition
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.presenting = true
		return transition
	}
	
	func isUserFollowingUser() -> Bool {
		let followed = DataController.sharedInstance.getCurrentUserModel()?.following.contains(self.userId) ?? false
		return followed
	}
	
	
	internal func dc_journeyModelsDidUpdate() {
		//
	}
	
	internal func dc_loveModelsDidUpdate() {
		//
	}
	
	internal func dc_followModelsDidUpdate() {
		DataController.sharedInstance.getCurrentUserInfo { (userInfo) in
			self.headerView.updateIconisFollowed(isFollowed: self.isUserFollowingUser())
		}
		self.hud?.hide(animated: true, afterDelay: 1);
		self.fetchUserData()
	}
	
}

