class UserInfoModel: AnyObject {
    public let name: String
    public let summary: String
    public let journeyModels: [String]
    public let planModels: [String]
    public let loveModels: [String]
    public let avatarUrl: String
    public let following: [String]
    public let hasFollowing: Bool
    public let hasJourneys: Bool
    public let hasPlans: Bool
    public let hasLoves: Bool
    
    public init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as! String
        self.summary = dictionary["summary"] as! String
        self.avatarUrl = dictionary["avatarUrl"] as! String
        
        var journeysFiltered = [String]()
        var plansFiltered = [String]()
        var lovesFiltered = [String]()
        var followersFiltered = [String]()

        if let userJourneys = dictionary["journeys"] as? [String: AnyObject] {
            for (_,element) in userJourneys {
                if let str = element as? String {
                    journeysFiltered.append(str)
                }
            }
        }
        self.journeyModels = journeysFiltered
        
        if let userPlans = dictionary["plans"] as? [String: AnyObject] {
            for (_,element) in userPlans {
                if let str = element as? String {
                    plansFiltered.append(str)
                }
            }
        }
        self.planModels = plansFiltered
        
        if let userLoves = dictionary["loves"] as? [String: AnyObject] {
            for (_,element) in userLoves {
                if let str = element as? String {
                    lovesFiltered.append(str)
                }
            }
        }
        self.loveModels = lovesFiltered
        
        if let following = dictionary["following"] as? [String: AnyObject] {
            for (_,element) in following {
                if let str = element as? String {
                    followersFiltered.append(str)
                }
            }
        }
        self.following = followersFiltered
        
        self.hasLoves = self.loveModels.count > 0
        self.hasJourneys = self.journeyModels.count > 0
        self.hasPlans = self.planModels.count > 0
        self.hasFollowing = self.following.count > 0
    }
}
