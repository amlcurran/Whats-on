import UIKit

extension UIView {

    func constrain(toSuperview edges: NSLayoutAttribute..., insetBy inset: CGFloat = 0) {
        for edge in edges {
            constrain(toSuperview: edge, withOffset: offset(for: edge, ofInset: inset))
        }
    }

    func constrain(toSuperviewSafeArea edges: NSLayoutAttribute..., insetBy inset: CGFloat = 0) {
        _ = prepareForConstraints()
        var edges = edges
        if edges.contains(.leading) {
            leadingAnchor.constraint(equalTo: superview!.leadingSafeAnchor,
                constant: offset(for: .leading, ofInset: inset)).isActive = true
            edges.remove(.leading)
        }
        if edges.contains(.trailing) {
            trailingAnchor.constraint(equalTo: superview!.trailingSafeAnchor,
                constant: offset(for: .trailing, ofInset: inset)).isActive = true
            edges.remove(.trailing)
        }
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: superview!.topSafeAnchor,
                constant: offset(for: .top, ofInset: inset)).isActive = true
            edges.remove(.top)
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview!.bottomSafeAnchor,
                constant: offset(for: .bottom, ofInset: inset)).isActive = true
            edges.remove(.bottom)
        }
        if edges.isEmpty == false {
            debugPrint("Constraining to superview safe area was left with the following unconstrained attributes: \(edges)")
        }
    }

    private var leadingSafeAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }

    private var trailingSafeAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }

    private var topSafeAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }

    private var bottomSafeAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }

    func constrain(toSafeAreaTopOf viewController: UIViewController, insetBy inset: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        } else {
            topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor, constant: inset).isActive = true
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

    @available(iOS 11.0, *)
    func constrainToSafeAreaBottom(of viewController: UIViewController, insetBy inset: CGFloat = 0) {
        bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -inset).isActive = true
    }

    @discardableResult func constrain(toSuperview edge: NSLayoutAttribute, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
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

    func constrain(to view: UIView, edges: NSLayoutAttribute..., withOffset offset: CGFloat = 0) {
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
        for edge in edges {
            view.constrain(toSuperview: edge, insetBy: inset)
        }
    }

    private func prepareForConstraints() -> UIView {
        guard let superview = self.superview else {
            fatalError("view doesn't have a superview")
        }
        translatesAutoresizingMaskIntoConstraints = false
        return superview
    }

    func hugContent(_ axis: UILayoutConstraintAxis) {
        setContentHuggingPriority(.required, for: axis)
    }

}

private extension Array where Element == NSLayoutAttribute {

    mutating func remove(_ attribute: NSLayoutAttribute) {
        if let foundIndex = index(of: attribute) {
            remove(at: foundIndex)
        }
    }

}
