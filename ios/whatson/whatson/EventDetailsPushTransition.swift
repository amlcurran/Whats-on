import UIKit

class EventDetailsPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.viewController(forKey: .from)?.view,
            let toController = transitionContext.viewController(forKey: .to),
            let toView = toController.view else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        
        let container = transitionContext.containerView
        container.addSubview(fromView)
        container.addSubview(toView)
        toView.scaleY = 0
        UIView.animate(withDuration: 0.2, animations: { 
            toView.scaleY = 1
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

extension UIView {
    
    var scaleY: CGFloat {
        get {
            return transform.d
        }
        set {
            transform = CGAffineTransform(scaleX: 1, y: newValue)
        }
    }
    
}
