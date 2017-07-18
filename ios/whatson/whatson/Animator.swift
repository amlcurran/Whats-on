import Foundation

protocol Animator {
    func animate(withDuration duration: TimeInterval, _ animation: @escaping () -> Void, completion: @escaping () -> Void) -> Animation?
}

extension Animator {

    func animate(withDuration duration: TimeInterval, _ animation: @escaping () -> Void) -> Animation? {
        return animate(withDuration: duration, animation, completion: {})
    }

}

protocol Animation {
    func start()
}

class AnimatorHolder {
    static let animator: Animator = {
        if #available(iOS 10.0, *) {
            return PropertyAnimator()
        } else {
            return BasicAnimator()
        }
    }()
}
