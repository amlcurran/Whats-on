import UIKit

class EventDetailsPushTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var selectedIndexPath: IndexPath?

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
                let listVC = transitionContext.viewController(forKey: .from) as? WhatsOnViewController,
                let detailVC = transitionContext.viewController(forKey: .to) as? EventDetailsViewController,
                let indexPath = selectedIndexPath,
                let row = listVC.tableView.cellForRow(at: indexPath)?.contentView.snapshotView(afterScreenUpdates: false),
                let fromView = transitionContext.view(forKey: .from),
                let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            print("ruh roh")
            return
        }

//        listVC.beginAppearanceTransition(false, animated: true)
//        detailVC.beginAppearanceTransition(true, animated: true)
        detailVC.view.layoutIfNeeded()

        let container = transitionContext.containerView
        container.addSubview(fromView)
        container.addSubview(row)
        container.addSubview(toView)

        toView.alpha = 0
        row.frame = listVC.tableView.convert(listVC.tableView.rectForRow(at: indexPath), to: nil)

        UIView.animate(withDuration: 0.2, animations: {
            row.frame.origin.y = detailVC.detailsCard.convert(detailVC.detailsCard.frame.origin, to: nil).y
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                toView.alpha = 1
            }, completion: { _ in
//                listVC.endAppearanceTransition()
//                detailVC.endAppearanceTransition()
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

}
