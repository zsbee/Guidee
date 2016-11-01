class UserInfoModel: AnyObject {
    public let name: String
    public let summary: String
    public let journeyModels: [String]
    public let avatarUrl: String
    
    public init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as! String
        self.summary = dictionary["summary"] as! String
        self.avatarUrl = dictionary["avatarUrl"] as! String
        self.journeyModels = dictionary["journeys"] as! [String]
    }
}
