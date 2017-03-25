import UIKit

private let slideDuration: TimeInterval = 0.2
private let alphaDuration: TimeInterval = 0.2

class EventDetailsPushTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var selectedIndexPath: IndexPath?

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return slideDuration + alphaDuration
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
        let backgroundView = UIView(frame: container.frame, color: .windowBackground)
        container.addSubview(fromView)
        container.addSubview(backgroundView)
        container.addSubview(rowCardSnapshot)
        container.addSubview(toView)

        toView.alpha = 0
        backgroundView.alpha = 0
        rowCardSnapshot.frame = row.absoluteFrame(of: row.roundedView)

        UIView.animate(withDuration: slideDuration, animations: {
            backgroundView.alpha = 1
            rowCardSnapshot.frame.origin.y = detailVC.detailsCard.absoluteFrame().origin.y + 12
        }, completion: { _ in
            UIView.animate(withDuration: alphaDuration, animations: {
                toView.alpha = 1
            }, completion: { _ in
                rowCardSnapshot.removeFromSuperview()
                fromView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                detailVC.detailsCard.expandTitleAndTimeGap()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
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
