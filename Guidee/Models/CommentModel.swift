import Foundation

class CommentModel: AnyObject {
    let authorName: String
    let avatarUrl: String
    let comment: String
    
    public init(dictionary: [String: AnyObject]) {
        self.authorName = dictionary["author"] as! String
        self.comment = dictionary["comment"] as! String
        self.avatarUrl = dictionary["avatarURL"] as! String
    }
}
