import UIKit

class BasicAnimator: Animator {

    func animate(withDuration duration: TimeInterval, _ animation: @escaping () -> Void, completion: @escaping () -> Void) -> Animation? {
        return BasicAnimation(animation: animation, completion: completion, duration: duration)
    }

}

private struct BasicAnimation: Animation {

    let animation: () -> Void
    let completion: () -> Void
    let duration: TimeInterval

    func start() {
        UIView.animate(withDuration: duration, animations: animation, completion: { _ in
            self.completion()
        })
    }
}
