import UIKit

class EventDetailsPushTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var selectedIndexPath: IndexPath?

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
                let listVC = transitionContext.viewController(forKey: .from) as? WhatsOnViewController,
                let detailVC = transitionContext.viewController(forKey: .to) as? EventDetailsViewController,
                let indexPath = selectedIndexPath,
                let row = listVC.tableView.cellForRow(at: indexPath) as? CalendarSourceViewCell,
                let fromView = transitionContext.view(forKey: .from),
                let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        detailVC.view.layoutIfNeeded()
        row.layoutIfNeeded()

        guard let rowCardSnapshot = row.roundedView.snapshotView(afterScreenUpdates: false) else {
            return
        }

        let container = transitionContext.containerView
        let background = UIView(frame: container.frame, color: .windowBackground)
        container.addSubview(fromView)
        container.addSubview(background)
        container.addSubview(rowCardSnapshot)
        container.addSubview(toView)

        toView.alpha = 0
        background.alpha = 0
        rowCardSnapshot.frame = row.convert(row.roundedView.frame, to: nil)

        UIView.animate(withDuration: 0.3, delay: 0, options: [UIViewAnimationOptions.curveEaseInOut], animations: {
            background.alpha = 1
            rowCardSnapshot.frame.origin.y = detailVC.detailsCard.convert(detailVC.detailsCard.frame.origin, to: nil).y + 12
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                toView.alpha = 1
            }, completion: { _ in
                rowCardSnapshot.removeFromSuperview()
                fromView.removeFromSuperview()
                background.removeFromSuperview()
                detailVC.detailsCard.expandTitleAndTimeGap()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
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

    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = color
    }

}
