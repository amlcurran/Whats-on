import UIKit

@available(iOS 10.0, *)
class PropertyAnimator: Animator {

    func animate(withDuration duration: TimeInterval, _ animation: @escaping () -> Void, completion: @escaping () -> Void) -> Animation? {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0, animations: animation)
        propertyAnimator.addCompletion({ _ in
            completion()
        })
        return PropertyAnimation(animation: propertyAnimator)
    }

}

@available(iOS 10.0, *)
private struct PropertyAnimation: Animation {

    let animation: UIViewPropertyAnimator

    func start() {
        animation.startAnimation()
    }
}
