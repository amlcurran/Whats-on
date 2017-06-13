import Foundation

extension Optional {

    func required(message: @autoclosure () -> String = "Requirement was nil", file: StaticString = #file, line: UInt = #line) -> Wrapped {
        if let unwrapped = self {
            return unwrapped
        } else {
            preconditionFailure(message(), file: file, line: line)
        }
    }

    func required<T>(as type: T.Type) -> T {
        if let requiredCast = required() as? T {
            return requiredCast
        } else {
            preconditionFailure("Couldn't cast \(String(describing: self)) to \(T.self)")
        }
    }

}
