import XCTest
@testable import What_s_on

class EventPredicateTests: XCTestCase {

    func testSingleTruePredicateReturnsTrue() {
        let test = NSPredicate(compoundFrom: [truePredicate()])

        XCTAssertTrue(test.evaluate(with: ""))
    }

    func testSingleFalsePredicateReturnsFalse() {
        let test = NSPredicate(compoundFrom: [falsePredicate()])

        XCTAssertFalse(test.evaluate(with: ""))
    }

    func testMixedPredicatesReturnFalse() {
        let test = NSPredicate(compoundFrom: [truePredicate(), falsePredicate()])

        XCTAssertFalse(test.evaluate(with: ""))
    }

    func testFullyTruePredicatesReturnTrue() {
        let test = NSPredicate(compoundFrom: [truePredicate(), truePredicate()])

        XCTAssertTrue(test.evaluate(with: ""))
    }

}

private func truePredicate() -> NSPredicate {
    return NSPredicate(value: true)
}

private func falsePredicate() -> NSPredicate {
    return NSPredicate(value: false)
}
