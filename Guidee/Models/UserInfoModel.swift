class UserInfoModel: AnyObject {
    public let name: String
    public let summary: String
    public let journeyModels: [String]
    public let planModels: [String]
    public let loveModels: [String]
    public let avatarUrl: String
    public let following: [String]
    
    public init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as! String
        self.summary = dictionary["summary"] as! String
        self.avatarUrl = dictionary["avatarUrl"] as! String
        
        var journeysFiltered = [String]()
        
        if let userJourneys = dictionary["journeys"] as? [String: AnyObject] {
            for (_,element) in userJourneys {
                if let str = element as? String {
                    journeysFiltered.append(str)
                }
            }
        }
        
        self.journeyModels = journeysFiltered
        self.planModels = dictionary["plans"] as! [String]
        self.loveModels = dictionary["loves"] as! [String]
        self.following = dictionary["following"] as! [String]
    }
}
