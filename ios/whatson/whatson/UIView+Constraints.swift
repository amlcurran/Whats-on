import UIKit

extension UIView {

    func constrainToSuperview(_ edges: [NSLayoutAttribute], insetBy inset: CGFloat = 0) {
        for edge in edges {
            constrainToSuperview(edge, withOffset: offset(for: edge, ofInset: inset))
        }
    }

    private func offset(for edge: NSLayoutAttribute, ofInset inset: CGFloat) -> CGFloat {
        switch edge {
        case .top, .topMargin, .leading, .leadingMargin:
            return inset
        case .bottom, .bottomMargin, .trailing, .trailingMargin:
            return -inset
        default:
            print("Warning, offset not handled for edge \(edge)")
            return inset
        }
    }

    @discardableResult func constrainToSuperview(_ edge: NSLayoutAttribute, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        let superview = prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: superview, attribute: edge, multiplier: 1, constant: offset)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func constrain(to view: UIView, _ edge: NSLayoutAttribute, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: view, attribute: edge, multiplier: 1, constant: offset)
        constraint.isActive = true
        return constraint
    }

    func constrain(to view: UIView, edges: [NSLayoutAttribute], withOffset offset: CGFloat = 0) {
        for edge in edges {
            constrain(to: view, edge, withOffset: offset)
        }
    }

    @discardableResult func constrain(height: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func constrain(width: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        constraint.isActive = true
        return constraint
    }

    func hideConstraint() -> NSLayoutConstraint {
        return constrain(height: 0)
    }

    @discardableResult func constrain(_ edge: NSLayoutAttribute, to view: UIView, _ otherEdge: NSLayoutAttribute, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        _ = prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: view, attribute: otherEdge, multiplier: 1, constant: offset)
        constraint.isActive = true
        return constraint
    }

    func add(_ view: UIView, constrainedTo edges: [NSLayoutAttribute], withInset inset: CGFloat = 0) {
        addSubview(view)
        view.constrainToSuperview(edges, insetBy: inset)
    }

    private func prepareForConstraints() -> UIView {
        guard let superview = self.superview else {
            fatalError("view doesn't have a superview")
        }
        translatesAutoresizingMaskIntoConstraints = false
        return superview
    }

    func hugContent(_ axis: UILayoutConstraintAxis) {
        setContentHuggingPriority(UILayoutPriority.required, for: axis)
    }

    func surroundedByView(insetBy inset: CGFloat) -> UIView {
        return surrounded(by: UIView(), inset: inset)
    }

    //swiftlint:disable:next colon this is the formatting for constrained generics
    func surrounded<T:UIView>(by view: T, inset: CGFloat) -> T {
        view.addSubview(self)
        constrainToSuperview([.leading, .top, .trailing, .bottom], insetBy: inset)
        return view
    }

}
