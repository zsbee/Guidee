import UIKit
import AsyncDisplayKit

protocol JourneyEditorViewControllerDelegate {
    func didFinishUploadingToDatabase()
}

class JourneyEditorViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, JourneyEditorHeaderViewDelegate, EventCellNodeDelegate, EditTextViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GuideEventEditorViewControllerDelegate, MapCellNodeDelegate {
   
    let headerView: JourneyEditorHeaderView = JourneyEditorHeaderView()
    var collectionNode: ASCollectionNode!
    
    // Node map
    private let sectionIndexHeader: Int = 0
    private let sectionIndexSummaryHeader: Int = 1
    private let sectionIndexSummary: Int = 2
    private let sectionIndexDetailsHeader: Int = 3
    private let sectionIndexDetails = 4
    private let sectionIndexMapHeader: Int = 5
    private let sectionIndexMap = 6
    
    private var eventNodeSize: CGSize!
    
    private var baseModel: GuideBaseModel!
    private var mutatedModel: MutableGuideBaseModel!
    
    public var delegate:JourneyEditorViewControllerDelegate?
    
    public var mapCenter: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        
        self.headerView.delegate = self
        
        eventNodeSize = CGSize(width: self.view.frame.width, height: 92)
        
        self.view.backgroundColor = UIColor.white
        
        DataController.sharedInstance.getEditableJourneyModel { (baseModel) in
            self.baseModel = baseModel
            self.mutatedModel = baseModel.mutableObject()
            self.view.addSubnode(self.collectionNode)
            self.view.addSubview(self.headerView)
        }
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
        case self.sectionIndexMapHeader:
            return UIEdgeInsetsMake(16, 0, 0, 0)
        case self.sectionIndexMap:
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
                let node = GuideHeaderCellNode(coverImageUrl: self.mutatedModel.coverImageUrl, attributedText: NSAttributedString(string: self.mutatedModel.title, attributes: TextStyles.getCenteredTitleAttirbutes()), avatarUrl: self.mutatedModel.userAvatarUrl)
                return node
            case self.sectionIndexSummaryHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Summary", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexSummary:
                let node = GuideSummaryTextNode(attributedText: NSAttributedString(string: self.mutatedModel.summary , attributes: TextStyles.getSummaryTextFontAttributes()))
                return node
            case self.sectionIndexDetailsHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Spots", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexDetails:
                return EventCellNode(models: self.mutatedModel.eventModels,delegate: self, detailCellSize: self.eventNodeSize)
            case self.sectionIndexMapHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Set location", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexMap:
                let node = MapCellNode(mapCenterCoordinate: self.mapCenter)
                node.delegate = self
                return node
            default:
                return ASCellNode()
            }
        }
    }
    
    public func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right;
        
        if(indexPath.section == sectionIndexDetails) {
            let numberOfItems = self.mutatedModel.eventModels.count
            let nodeHeight = CGFloat(numberOfItems) * self.eventNodeSize.height
            return ASSizeRangeMake(CGSize(width: self.eventNodeSize.width, height: nodeHeight), CGSize(width: self.eventNodeSize.width, height: nodeHeight))
        }
        
        return ASSizeRangeMake(CGSize(width: width, height:0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EditTextViewController()
        vc.delegate = self
        
        switch indexPath.section {
        case self.sectionIndexSummary:
            let textViewText = (self.baseModel.summary != self.mutatedModel.summary) ? self.mutatedModel.summary : ""
            vc.viewModel = EditTextSetupViewModel(title: "Edit Summary", sectionIndex: self.sectionIndexSummary, placeHolder: "Edit Summary of Guide", text: textViewText)
            self.present(vc, animated: true, completion:nil)

        case self.sectionIndexHeader:
            // show actionsheet/alertcontroller
            let alertController = UIAlertController(title: "Edit header information", message: nil, preferredStyle: .actionSheet)
            
            let editTitleAction = UIAlertAction(title: "Edit title", style: .default) { (_) in
                let textViewText = (self.baseModel.title != self.mutatedModel.title) ? self.mutatedModel.title : ""
                vc.viewModel = EditTextSetupViewModel(title: "Edit title", sectionIndex: self.sectionIndexHeader, placeHolder: "Edit title of journey", text: textViewText)
                
                self.present(vc, animated: true, completion:nil)
            }
            let uploadImageAction = UIAlertAction(title: "Upload Cover Image", style: .default) { (_) in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addAction(editTitleAction)
            alertController.addAction(uploadImageAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: { 
                //
            })
            return
        default:
            return
        }
    }
    
    // Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        self.collectionNode.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    // Header
    func header_cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func header_saveButtonTapped() {
        let uuid = UUID().uuidString
        self.mutatedModel.identifier = uuid
        self.mutatedModel.annotationModel.identifier = uuid
        
        self.mutatedModel.eventModels = self.filteredEventModels()
        
        DataController.sharedInstance.saveGuideToFirebase(mutatedGuide: self.mutatedModel, completionBlock: { () in
            self.delegate?.didFinishUploadingToDatabase()
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func filteredEventModels() -> [GuideEventDetailModel] {
        var filteredArr = [GuideEventDetailModel]()
        
        var i = 0
        for event in self.mutatedModel.eventModels {
            if (i != 0) {
                var carouselModels = event.carouselModels
                carouselModels.remove(at: carouselModels.count - 1)
                let eventModel = GuideEventDetailModel(title: event.title, summary: event.summary, carouselModels: carouselModels, coordinates: event.coordinates)
                
                filteredArr.append(eventModel)
            }
            i += 1
        }
        
        return filteredArr
    }
    
    // EditTextVC
    internal func editTextViewController_saveTappedWithString(string: String, sectionIndex: Int) {
        if string.isEmpty {
            return
        }
        
        switch sectionIndex {
        case self.sectionIndexSummary:
            self.mutatedModel.summary = string
            break
        case self.sectionIndexHeader:
            self.mutatedModel.title = string
            self.mutatedModel.annotationModel.title = string
            self.checkHeaderState()
            break
        default:
            break
        }
        
        self.reloadItemAtIndex(sectionIndex: sectionIndex)
    }
    
    internal func guideEventTapped(model: GuideEventDetailModel, atIndex: Int) {
        let vc = GuideEventEditorViewController()
        vc.mutatedModel = model.mutableObject()
        vc.delegate = self
        vc.spotIndex = atIndex
        
        self.present(vc, animated: true, completion:nil)
    }
    
    internal func spotSavedWithModel(immutableModel: GuideEventDetailModel, spotIndex: Int) {
        if(spotIndex == 0) {
            self.mutatedModel.eventModels.append(immutableModel)
        }
        else {
            self.mutatedModel.eventModels.remove(at: spotIndex)
            self.mutatedModel.eventModels.insert(immutableModel, at: spotIndex)
        }
        
        self.reloadItemAtIndex(sectionIndex: self.sectionIndexDetails)
    }

    
    // Image Picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { 
            //
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImageJPEGRepresentation(originalImage, 0.8)
            if let imageData = imageData {
                DataController.sharedInstance.uploadImageToFirebase(imageData: imageData, completionBlock: { (string) in
                    if let urlString = string {
                        self.mutatedModel.coverImageUrl = urlString
                        self.checkHeaderState()

                        self.reloadItemAtIndex(sectionIndex: self.sectionIndexHeader)
                    }
                })
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func checkHeaderState() {
        let coverImageModified = self.baseModel.coverImageUrl != self.mutatedModel.coverImageUrl
        let titleModified = self.baseModel.title != self.mutatedModel.title
        
        if (titleModified && coverImageModified) {
            // Load User avatar
            DataController.sharedInstance.getCurrentUserInfo(completionBlock: { (userInfoModel) in
                self.mutatedModel.userAvatarUrl = userInfoModel.avatarUrl
                
                self.reloadItemAtIndex(sectionIndex: self.sectionIndexHeader)
            })
        }
    }
    
    func reloadItemAtIndex(sectionIndex: Int) {
        self.collectionNode.view.performBatchUpdates({
            self.collectionNode.view.reloadItems(at: [IndexPath.init(row: 0, section: sectionIndex)])
            }, completion: nil)
    }
    
    func mapCenterDidUpdateWithCoordinates(coordinates: CLLocationCoordinate2D) {
        self.mutatedModel.annotationModel.coordinate = coordinates
    }
    
}
