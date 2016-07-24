import XCTest
@testable import What_s_On

class EventPredicateTests: XCTestCase {
    
    func testSingleTruePredicateReturnsTrue() {
        let test = EventPredicates.compound(from: [truePredicate()])
        
        XCTAssertTrue(test.evaluate(with: ""))
    }
    
    func testSingleFalsePredicateReturnsFalse() {
        let test = EventPredicates.compound(from: [falsePredicate()])
        
        XCTAssertFalse(test.evaluate(with: ""))
    }
    
    func testMixedPredicatesReturnFalse() {
        let test = EventPredicates.compound(from: [truePredicate(), falsePredicate()])
        
        XCTAssertFalse(test.evaluate(with: ""))
    }
    
    func testFullyTruePredicatesReturnTrue() {
        let test = EventPredicates.compound(from: [truePredicate(), truePredicate()])
        
        XCTAssertTrue(test.evaluate(with: ""))
    }
    
}

private func truePredicate() -> Predicate {
    return Predicate(value: true)
}

private func falsePredicate() -> Predicate {
    return Predicate(value: false)
}
