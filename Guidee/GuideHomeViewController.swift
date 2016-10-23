import UIKit
import AsyncDisplayKit

class GuideHomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource, GuideHeaderViewDelegate, EventCellNodeDelegate {

    let headerView: GuideHeaderView = GuideHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    public var baseModel: GuideBaseModel!
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
                let node = GuideHeaderCellNode(coverImageUrl: self.baseModel.coverImageUrl, attributedText: NSAttributedString(string: self.baseModel.title, attributes: TextStyles.getCenteredTitleAttirbutes()), avatarUrl: self.baseModel.userAvatarUrl)
                return node
            case self.sectionIndexSummaryHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Summary", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexSummary:
                let node = GuideSummaryTextNode(attributedText: NSAttributedString(string: self.baseModel.summary , attributes: TextStyles.getSummaryTextFontAttributes()))
                return node
            case self.sectionIndexDetailsHeader:
                let node = SectionHeaderNode(attributedText: NSAttributedString(string: "Spots", attributes: TextStyles.getHeaderFontAttributes()))
                return node
            case self.sectionIndexDetails:
                return EventCellNode(models: self.baseModel.eventModels,delegate: self, detailCellSize: self.eventNodeSize)
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
    
    public static func getMockedModel1() -> [GuideEventDetailModel] {
        var models = [GuideEventDetailModel]()
        
        models.append(GuideEventDetailModel(title: "Cala Varques",
                                            summary: "This magical coast outside of civilization can be found 35 minutes walk time from the main road. You can't go to the beach with Car or Bicycle",
                                            carouselModels: self.calaVarques()))
        models.append(GuideEventDetailModel(title: "Cala Pala",
                                            summary: "This is a boring coast without any limitations whatsoever, lorem ipsum",
                                            carouselModels: self.CalaPala()))

        
        return models
    }

    public static func getMockedModel2() -> [GuideEventDetailModel] {
        var models = [GuideEventDetailModel]()
        
        models.append(GuideEventDetailModel(title: "Ko Rok Noi",
                                            summary: "Brilliant white-sand beaches, crystal-clear water, expansive coral reefs and metre-long monitor lizards: welcome to Ko Rok.",
                                            carouselModels: self.koRokNoi()))
        models.append(GuideEventDetailModel(title: "Ko Adang",
                                            summary: "Brooding, densely forested hills, white-sand beaches and healthy coral reefs. Lots of snorkelling tours make a stop here. ",
                                            carouselModels: self.koAdang()))
        
        
        return models
    }
    
    public static func getMockedModel3() -> [GuideEventDetailModel] {
        var models = [GuideEventDetailModel]()
        
        models.append(GuideEventDetailModel(title: "Pigeon Point Heritage Park",
                                            summary: "The VERY famous Pigeon Point Heritage Park is one of the most recognizable places to visit here in Tobago.  I am sure you can see why, with its pristine beaches (some of the best in Tobago) and the famous thatched roof jetty.",
                                            carouselModels: self.pigeonPoint()))
        
        models.append(GuideEventDetailModel(title: "No Man’s Land",
                                            summary: "No Man’s Land, a split of white coral-sand stretching out in front of the Bon Accord Lagoon. The name is as you’ve guess, owned by no man.\n\nIt is a beautiful little slice of paradise many people like to visit on an afternoon to enjoy a swim or make a BBQ and watch Pigeon Point over in the distance.\n\nNow there are a couple ways to get out to No Man’s Land; there is the most common way by boat, which many tour operators will take you out to, and then there is by vehicle.",
                                            carouselModels: self.noMansLand()))
        
        models.append(GuideEventDetailModel(title: "Orean Horse Ride",
                                            summary: "Healing with Horses  is a non-profit organization that does therapeutic-riding, leadership-training, riding lessons and more, for differently abled children.\n\nFirstly you learn a bit about each of the horses, and then you are selected by a horse to ride. (A process of sticking your hand out with crackers and seeing which one comes to you.)\n\nThen onto the horse ride which was natural riding, bit-less and with no stirrups.\n\nWe were lucky to see a giant Eagle Ray pop out and swim right in between us.",
                                            carouselModels: self.horses()))
        
        models.append(GuideEventDetailModel(title: "Kariwak or Speyside",
                                            summary: "Tobago has a variety of spectacular diving site all around the island.\n\nOn the Caribbean side, there is the Kariwak Reef and  Flying Reef.\n\nAccessible with R & Sea Divers or Undersea Tobago.\n\nOn the Atlantic side near Speyside are several dive sites. Accessible with Blue Waters Diven.",
                                            carouselModels: self.diven()))
        
        
        models.append(GuideEventDetailModel(title: "Cocoa Estate",
                                            summary: "Are you a lover of chocolate? Check out the Tobago Cocoa Estate for a tour of their cocoa lands.\n\nNow for those that don’t know, cocoa is the dried and fermented fatty seeds used to make chocolate, which comes from the cocoa pods, which come from the cocoa tress.\n\nEach cocoa tree produces approx. 25-50 pods each year, after birds and squirrels have taken their cut. And on this estate there are approx. 23,000 trees. Just think of all that chocolate!",
                                            carouselModels: self.cocoa()))
        
        
        return models
    }
    
    
    public static func calaVarques() -> [CarouselItemModel] {
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acbfb7037.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: nil, videoId: "_dbyJdayCTU"))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc54103f.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc77d68b.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acca50fe4.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3accb4d595.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc88e552.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc95de51.jpg", videoId: nil))
        
        return models
    }
    
    
    public static func CalaPala() -> [CarouselItemModel] {
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acca50fe4.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acbfb7037.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: nil, videoId: "_dbyJdayCTU"))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc54103f.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc77d68b.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3accb4d595.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc88e552.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/3acc95de51.jpg", videoId: nil))
        
        return models
    }
    
    
    public static func koRokNoi() -> [CarouselItemModel] {
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://newmedia.thomson.co.uk/live/vol/2/2afde80c7945c083a3139e40fae7a0f79c2d4a03/1080x608/web/ASIAFAREASTTHAILANDTHAILANDDES_000423KRABI.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/b95b032a1a.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: nil, videoId: "4NAwwIMquqU"))
        
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/b95d75581c.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://www.experiencetravelgroup.com/reposit/20150805130658.jpg", videoId: nil))
        return models
    }
    
    
    public static func koAdang() -> [CarouselItemModel] {
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/b95b032a1a.jpg", videoId: nil))

        models.append(CarouselItemModel(imageURL: "https://www.experiencetravelgroup.com/reposit/20150805130658.jpg", videoId: nil))
        models.append(CarouselItemModel(imageURL: "https://i.imgsafe.org/b95d75581c.jpg", videoId: nil))

        models.append(CarouselItemModel(imageURL: nil, videoId: "4NAwwIMquqU"))
        models.append(CarouselItemModel(imageURL: "https://newmedia.thomson.co.uk/live/vol/2/2afde80c7945c083a3139e40fae7a0f79c2d4a03/1080x608/web/ASIAFAREASTTHAILANDTHAILANDDES_000423KRABI.jpg", videoId: nil))

        return models
    }
    
    public static func pigeonPoint() -> [CarouselItemModel] {
        
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Pigeon-Point-Tobago-.jpg?resize=1080%2C703", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Pigeon-Point-Tobago-2.jpg?zoom=2&resize=600%2C351", videoId: nil))
        
        
        return models
        
    }
    
    
    public static func noMansLand() -> [CarouselItemModel] {
        
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/No-Mans-Land-Tobago-3.jpg?resize=1080%2C645", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/No-Mans-Land-Tobago.jpg?resize=683%2C1024", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/No-Mans-Land-Tobago-4.jpg?w=1024", videoId: nil))
        
        
        return models
        
    }
    
    
    public static func horses() -> [CarouselItemModel] {
        
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Healing-with-Horses-Tobago-2.jpg?w=1241", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Healing-with-Horses-Tobago-4.jpg?w=1240", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i0.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Healing-with-Horses-Tobago.jpg?w=1308", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Healing-with-Horses-Tobago-5.jpg?w=1000", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i0.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Healing-with-Horses-Tobago-3.jpg?w=1320", videoId: nil))
        
        
        return models
        
    }
    
    
    public static func diven() -> [CarouselItemModel] {
        
        var models = [CarouselItemModel]()
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Blue-Waters-Diven-Speyside-Tobago.jpg?resize=1080%2C704", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i0.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Diving-Tobago-2.jpg?resize=1080%2C711", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i0.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Blue-Waters-Diven-Speyside-Tobago-2.jpg?resize=1080%2C670", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/IMG_3774.jpg?w=820", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Diving-Tobago.jpg?w=1106", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Speyside-Tobago.jpg?zoom=2&resize=600%2C384", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Blue-Waters-Diven-Speyside-Tobago1.jpg?resize=1080%2C720", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Blue-Waters-Diven-Speyside-Tobago-3.jpg?w=1254", videoId: nil))
        
        
        return models
    }
    
    public static func cocoa() -> [CarouselItemModel] {
        var models = [CarouselItemModel]()
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Tobago-Cocoa-Estate-2.jpg?resize=1080%2C708", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i2.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Tobago-Cocoa-Estate-3.jpg?resize=683%2C1024", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i0.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Tobago-Cocoa-Estate-4.jpg?resize=1080%2C757", videoId: nil))
        
        models.append(CarouselItemModel(imageURL: "https://i1.wp.com/www.heynadine.com/wp-content/uploads/2014/09/Tobago-Cocoa-Estate.jpg?resize=1080%2C681", videoId: nil))
        
        return models
    }
    
    internal func guideEventTapped(model: GuideEventDetailModel) {
        let vc = GuideEventDetailsViewController()
        vc.model = model
        self.present(vc, animated: true, completion:nil)
    }

}
