import UIKit

class Line: UIView {

    let height: CGFloat

    init(height: CGFloat, color: UIColor) {
        self.height = height
        super.init(frame: .zero)
        self.backgroundColor = color
    }

    override init(frame: CGRect) {
        fatalError("Frame init not implemented")
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Coder init not implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if (superview != nil) {
            removeConstraints(constraints)
            constrain(height: height)
        }
    }


}
