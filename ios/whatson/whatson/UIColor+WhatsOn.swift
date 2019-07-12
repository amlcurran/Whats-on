import UIKit

extension UIColor {
    class var emptyOutline: UIColor {
        return UIColor(named: "emptyOutline")!
    }

    class var accent: UIColor {
        return UIColor(named: "accent")!
    }

    class var secondary: UIColor {
        return UIColor(named: "secondary")!
    }

    class var lightText: UIColor {
        return UIColor(named: "lightText")!
    }

    class var windowBackground: UIColor {
        return UIColor(named: "windowBackground")!
    }

    class var divider: UIColor {
        return UIColor(named: "divider")!
    }

    class var cardDivider: UIColor {
        return UIColor(named: "cardDivider")!
    }

    class var surface: UIColor {
        return UIColor(named: "surface")!
    }

    func darkened(by factor: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let darkRed = CGFloat(red - factor)
            let darkGreen = CGFloat(green - factor)
            let darkBlue = CGFloat(blue - factor)
            return UIColor(red: darkRed, green: darkGreen, blue: darkBlue, alpha: CGFloat(alpha))
        }
        return self
    }

}
