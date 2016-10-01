import Foundation

extension Optional {
    
    func or(_ backup: Wrapped) -> Wrapped {
        if let wrapped = self {
            return wrapped
        }
        return backup
    }
    
}

extension Optional where Wrapped: ExpressibleByArrayLiteral {
    
    func orEmpty() -> Wrapped {
        let emptyArray: Wrapped = []
        return or(emptyArray)
    }
    
}
