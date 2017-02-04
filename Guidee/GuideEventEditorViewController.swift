import UIKit
import AsyncDisplayKit

protocol GuideEventEditorViewControllerDelegate {
    func spotSavedWithModel(immutableModel: GuideEventDetailModel, spotIndex: Int)
}

class GuideEventEditorViewController: UIViewController, GuideEventEditorHeaderViewDelegate, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, EditTextViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CarouselCellNodeDelegate, MapCellNodeDelegate {
    
    let headerView: GuideEventEditorHeaderView = GuideEventEditorHeaderView()
    var collectionNode: ASCollectionNode!
    
    var baseModel: GuideEventDetailModel!
	var journeyBaseCoordinates: CLLocationCoordinate2D!
	
    public var mutatedModel: MutableGuideEventDetailModel? {
        didSet {
            self.baseModel = mutatedModel!.copy()
            headerView.titleLabel.text = self.mutatedModel!.title
        }
    }
    
    public var delegate: GuideEventEditorViewControllerDelegate?
    public var spotIndex: Int = 0
    
    private let sectionFirstCellInset: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 16, 0)
    private let sectionHeaderInset: UIEdgeInsets = UIEdgeInsetsMake(16, 0, 0, 0)
    private let sectionContentInset: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0)
    private let sectionLastCellInset: UIEdgeInsets = UIEdgeInsetsMake(16, 0, 32, 0)
    
    // Node map
    private let sectionIndexTitleHeader: Int = 0
    private let sectionIndexTitle: Int = 1
    private let sectionIndexSummaryHeader: Int = 2
    private let sectionIndexSummary: Int = 3
    private let sectionIndexCarouselHeader: Int = 4
    private let sectionIndexCarousel: Int = 5
    private let sectionIndexMapHeader: Int = 6
    private let sectionIndexMap: Int = 7
    private let sectionIndexAdvert: Int = 8
    
    // Fake
   // private let sectionIndexTitle: Int = 66

    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if (self.mutatedModel!.coordinates.latitude == 0 && self.mutatedModel!.coordinates.longitude == 0) {
			self.mutatedModel?.coordinates = self.journeyBaseCoordinates
		}
		
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
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case self.sectionIndexTitleHeader:
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
            
            switch indexPath.section {
            case self.sectionIndexTitleHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Title", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexTitle:
                let node = GuideEventSummaryTextNode(attributedText: NSAttributedString(string: self.mutatedModel!.title, attributes: TextStyles.getSummaryTextFontAttributes()))
                return node
            case self.sectionIndexSummaryHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Summary", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexSummary:
                let node = GuideEventSummaryTextNode(attributedText: NSAttributedString(string: self.mutatedModel!.summary, attributes: TextStyles.getSummaryTextFontAttributes()))
                return node
                
            case self.sectionIndexCarouselHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Images/Videos", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexCarousel:
                let node = CarouselCellNode(models: self.mutatedModel!.carouselModels)
                node.delegate = self
                return node
            case self.sectionIndexMapHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Map", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexMap:
                let node = MapCellNode(mapCenterCoordinate: self.mutatedModel!.coordinates)
                node.delegate = self;
                return node
                
            case self.sectionIndexAdvert:
                //let node = AdvertNode()
                //node.preferredFrameSize = CGSize(width: 375, height: 250)
                return ASCellNode()
            default:
                return ASCellNode()
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EditTextViewController()
        vc.delegate = self
        
        switch indexPath.section {
        case self.sectionIndexSummary:
            let textViewText = self.mutatedModel!.summary
            vc.viewModel = EditTextSetupViewModel(title: "Edit Summary", sectionIndex: self.sectionIndexSummary, placeHolder: "Edit Summary of Spot", text: textViewText)
            self.present(vc, animated: true, completion:nil)
        case self.sectionIndexTitle:
            let textViewText = self.mutatedModel!.title
            vc.viewModel = EditTextSetupViewModel(title: "Edit Title", sectionIndex: self.sectionIndexTitle, placeHolder: "Edit Title of Spot", text: textViewText)
            self.present(vc, animated: true, completion:nil)
        case self.sectionIndexCarousel:
            
            return
        default:
            return
        }
    }
    
    // Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        self.collectionNode.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height-60)
    }
    

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Header
    internal func header_saveButtonTapped() {
        self.delegate?.spotSavedWithModel(immutableModel: self.mutatedModel!.copy(), spotIndex: self.spotIndex)
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func header_cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func header_titleTapped() {
        let vc = EditTextViewController()
        vc.delegate = self
        
//        let textViewText = (self.baseModel.title != self.mutatedModel!.title) ? self.mutatedModel!.title : ""
//        vc.viewModel = EditTextSetupViewModel(title: "Edit title", sectionIndex: self.sectionIndexTitle, placeHolder: "Edit title of spot", text: textViewText)
//        self.present(vc, animated: true, completion:nil)
    }
    
    // EditTextVC
    internal func editTextViewController_saveTappedWithString(string: String, sectionIndex: Int) {
        if string.isEmpty {
            return
        }
        
        switch sectionIndex {
        case self.sectionIndexSummary:
            self.mutatedModel!.summary = string
            break
        case self.sectionIndexTitle:
            self.mutatedModel!.title = string
            //self.headerView.titleLabel.text = string
            break
        case self.sectionIndexCarousel:


            return
        default:
            break
        }
        
        
        
        self.reloadItemAtIndex(sectionIndex: sectionIndex)
        
    }
    
    func reloadItemAtIndex(sectionIndex: Int) {
        self.collectionNode.performBatchUpdates({
            self.collectionNode.reloadItems(at: [IndexPath.init(row: 0, section: sectionIndex)])
            }, completion: nil)
    }
    
    // Image Picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            //
        }
    }
	
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImageJPEGRepresentation(originalImage, 0.0)
            if let imageData = imageData {
                DataController.sharedInstance.uploadImageToFirebase(imageData: imageData, completionBlock: { (string) in
                    if let urlString = string {
                        self.mutatedModel?.carouselModels.insert(CarouselItemModel(imageURL: urlString, videoId: nil), at: 0)
                        self.reloadItemAtIndex(sectionIndex: self.sectionIndexCarousel)
                    }
                })
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // Carousel
    internal func carouselCellSelectedWithIndex(index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
	
    func mapCenterDidUpdateWithCoordinates(coordinates: CLLocationCoordinate2D) {
        self.mutatedModel!.coordinates = coordinates
    }
}
