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
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 40, weight: UIFontWeightHeavy)
        
        return attrs
    }
    
    internal static func getAdvertFontAttributes() -> [String:NSObject] {
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
    
    internal static func getCenteredTitleAttirbutes() -> [String:NSObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 0.0
        shadow.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.white
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 40, weight: UIFontWeightHeavy)
        attrs[NSParagraphStyleAttributeName] = paragraphStyle
        attrs[NSShadowAttributeName] = shadow
        
        return attrs
    }
    
    internal static func getJourneyCellTitleAttributes() -> [String:NSObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 0.0
        shadow.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.white
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        attrs[NSParagraphStyleAttributeName] = paragraphStyle
        attrs[NSShadowAttributeName] = shadow
        
        return attrs
    }
    
    internal static func getEventCellHeaderAttributes() -> [String:NSObject] {
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.black
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        
        return attrs
    }
    
    internal static func getFollowCellNameAttributes() -> [String:NSObject] {
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.black
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
        
        return attrs
    }
    
    internal static func getEventCellSummaryAttributes() -> [String:NSObject] {
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.black
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        
        return attrs
    }
    
    
    internal static func getHeartCounterAttributes() -> [String:NSObject] {
        var attrs = [String: NSObject]()
        attrs[NSForegroundColorAttributeName] = UIColor.black
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        
        return attrs
    }
    
}
