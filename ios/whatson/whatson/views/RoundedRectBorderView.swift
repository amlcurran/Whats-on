import UIKit

@IBDesignable
class RoundedRectBorderView: UIView {

    let borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        return layer
    }()

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            if bounds.size != CGSize(width: 0, height: 0) {
                let rect = bounds.insetBy(dx: cornerRadius, dy: cornerRadius)
                borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
            }
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            borderLayer.lineWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            borderLayer.strokeColor = borderColor?.cgColor
        }
    }
    var borderDash: Border = .full {
        didSet {
            switch borderDash {
            case .full:
                borderLayer.lineDashPattern = nil
                break
            case .dashed(let width):
                borderLayer.lineDashPattern = [NSNumber(value: width), NSNumber(value: width)]
                break
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(borderLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(borderLayer)
    }

    override func layoutSubviews() {
        borderLayer.frame = bounds
        let rect = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    }

}

enum Border {
    case full
    case dashed(width: Float)
}
