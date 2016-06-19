import UIKit

extension UIView {
    
    func constrainToSuperview(edge edge: NSLayoutAttribute, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        guard let superview = self.superview else {
            fatalError("view doesn't have a superview")
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .Equal, toItem: superview, attribute: edge, multiplier: 1, constant: offset)
        superview.addConstraint(constraint)
        return constraint
    }

}
