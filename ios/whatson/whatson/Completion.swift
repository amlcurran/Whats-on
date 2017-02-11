import Foundation

func when<T>(successful: @escaping ((T) -> Void), whenFailed: @escaping ((Error) -> Void)) -> ((T?, Error?) -> Void) {
    return { maybeResult, maybeError in
        if let result = maybeResult {
            successful(result)
        } else if let error = maybeError {
            whenFailed(error)
        } else {
            whenFailed(NoResultError())
        }
    }
}

func doNothing<T>(_ item: T) {
    // do nothing
}

class NoResultError: Error {

}