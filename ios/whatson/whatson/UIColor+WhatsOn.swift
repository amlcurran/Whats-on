import UIKit

extension UIColor {
    class var emptyOutline: UIColor {
        return UIColor(red: 194.0 / 255.0, green: 207.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }

    class var accent: UIColor {
        return UIColor(red: 58.0 / 255.0, green: 217.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
    }

    class var secondary: UIColor {
        return UIColor(red: 68.0 / 255.0, green: 82.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)
    }

    class var lightText: UIColor {
        return UIColor(red: 186.0 / 255.0, green: 194.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
    }

    class var windowBackground: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 241.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }

    class var divider: UIColor {
        return UIColor(red: 226.0 / 255.0, green: 233.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }

    class var cardDivider: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }

    func darken(by factor: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let darkRed = Float(red - factor)
            let darkGreen = Float(green - factor)
            let darkBlue = Float(blue - factor)
            return UIColor(colorLiteralRed: darkRed, green: darkGreen, blue: darkBlue, alpha: Float(alpha))
        }
        return self
    }

}
