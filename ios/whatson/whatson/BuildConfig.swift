import Foundation

struct BuildConfig {

    private static func isDebug() -> Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }

    struct Supports {

        static var eventResponses: Bool {
            return BuildConfig.isDebug()
        }

        static var eventEditing: Bool {
            return BuildConfig.isDebug()
        }

        static var eventTransitions: Bool {
            return true
        }

    }

}
