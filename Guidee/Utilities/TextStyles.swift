import UIKit

class TextStyles: AnyObject {
    internal static func Util(string: String, font: UIFont, color: UIColor) -> NSAttributedString {
            return NSAttributedString(
                string: string,
                attributes: [NSFontAttributeName: font,
                             NSForegroundColorAttributeName: color])
    }
    
    internal static func getHeaderFontAttributes() -> [String:NSObject] {
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.black
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        
        return attrs
    }
    
    
    internal static func getSummaryTextFontAttributes() -> [String:NSObject] {
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.black
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        
        return attrs
    }
    
}
