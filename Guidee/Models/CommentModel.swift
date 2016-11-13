import Foundation

class CommentModel: AnyObject {
    let authorName: String
    let avatarUrl: String
    let comment: String
    
    public init(dictionary: [String: AnyObject]) {
        self.authorName = "Jack The Random"
        self.comment = "Lorem Ipsum Dolor Sit Amet asjajksgjka skga skjgnasg als"
        self.avatarUrl = "https://pbs.twimg.com/profile_images/768529565966667776/WScYY_cq.jpg"
    }
    
}
