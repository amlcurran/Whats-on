import UIKit

extension UIView {
    
    func constrainToSuperview(edge: NSLayoutAttribute, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        let superview = prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: superview, attribute: edge, multiplier: 1, constant: offset)
        superview.addConstraint(constraint)
        return constraint
    }
    
    func constrain(height: CGFloat) -> NSLayoutConstraint {
        _ = prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        constraint.isActive = true
        return constraint
    }
    
    private func prepareForConstraints() -> UIView {
        guard let superview = self.superview else {
            fatalError("view doesn't have a superview")
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        return superview
    }

}
