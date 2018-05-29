import UIKit

private let slideDuration: TimeInterval = 0.2
private let alphaDuration: TimeInterval = 0.2

class EventDetailsPushTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var selectedIndexPath: IndexPath?
    var selectedCell: UITableViewCell?
    let animator: Animator = AnimatorHolder.animator

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return slideDuration + alphaDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
                let detailVC = transitionContext.viewController(forKey: .to) as? EventDetailsViewController,
                let row = selectedCell,
                let calendarRow = row as? EventCell,
                let fromView = transitionContext.view(forKey: .from),
                let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        calendarRow.layoutIfNeeded()

        guard let rowCardSnapshot = calendarRow.roundedView.snapshotView(afterScreenUpdates: false) else {
            return
        }

        let container = transitionContext.containerView
        let backgroundView = UIView(frame: container.frame, color: .windowBackground)
        container.addSubview(fromView)
        container.addSubview(backgroundView)
        container.addSubview(rowCardSnapshot)
        container.addSubview(toView)
        toView.setNeedsLayout()
        toView.layoutIfNeeded()

        toView.alpha = 0
        backgroundView.alpha = 0
        rowCardSnapshot.frame = row.absoluteFrame(of: calendarRow.roundedView)

        let secondAnimation = animator.animate(withDuration: alphaDuration, {
            toView.alpha = 1
        }, completion: {
            rowCardSnapshot.removeFromSuperview()
            fromView.removeFromSuperview()
            backgroundView.removeFromSuperview()
            detailVC.detailsCard.expandTitleAndTimeGap()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        let firstAnimation = animator.animate(withDuration: slideDuration, {
            backgroundView.alpha = 1
            rowCardSnapshot.frame.origin.y = detailVC.detailsCard.absoluteFrame().origin.y - 8
        }, completion: {
            secondAnimation?.start()
        })
        firstAnimation?.start()
    }

}

extension UIView {

    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = color
    }

}

extension UIView {

    func absoluteFrame(of view: UIView) -> CGRect {
        return convert(view.frame, to: nil)
    }

    func absoluteFrame() -> CGRect {
        return absoluteFrame(of: self)
    }

}
