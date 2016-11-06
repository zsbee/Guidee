import Foundation

class EditTextSetupViewModel: AnyObject {
    public let title: String
    public let sectionIndex: Int
    public let placeHolder: String
    public let text: String
    
    public init(title: String, sectionIndex: Int, placeHolder: String, text: String) {
        self.title = title
        self.placeHolder = placeHolder
        self.sectionIndex = sectionIndex
        self.text = text
    }
}
