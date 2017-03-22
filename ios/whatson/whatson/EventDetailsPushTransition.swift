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
        let backgroundView = UIView(frame: container.frame, color: .windowBackground)
        container.addSubview(fromView)
        container.addSubview(backgroundView)
        container.addSubview(rowCardSnapshot)
        container.addSubview(toView)

        toView.alpha = 0
        backgroundView.alpha = 0
        rowCardSnapshot.frame = row.convert(row.roundedView.frame, to: nil)

        UIView.animate(withDuration: 0.3, {
            backgroundView.alpha = 1
            rowCardSnapshot.frame.origin.y = detailVC.detailsCard.convert(detailVC.detailsCard.frame.origin, to: nil).y + 12
        }).then({
            toView.alpha = 1
        }).then({
            rowCardSnapshot.removeFromSuperview()
            fromView.removeFromSuperview()
            backgroundView.removeFromSuperview()
            detailVC.detailsCard.expandTitleAndTimeGap()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
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

extension UIView {

    static func animate(withDuration duration: TimeInterval, _ animations: @escaping (() -> Void)) -> Completable {
        let completable = Completable()
        UIView.animate(withDuration: duration, animations: animations, completion: { success in
            completable.completion?()
        })
        return completable
    }

    func fadeIn() {
        alpha = 1
    }

}

class Completable {

    var completion: (() -> Void)? = nil

    @discardableResult func then(_ completion: @escaping (() -> Void)) -> Completable {
        let completable = Completable()
        self.completion = {
            completion()
            completable.completion?()
        }
        return completable
    }

}
