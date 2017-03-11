import Foundation

struct BuildConfig {

    static func isDebug() -> Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }

}
