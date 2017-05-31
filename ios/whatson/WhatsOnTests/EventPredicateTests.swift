import XCTest
import EventKit
@testable import What_s_on

class EventPredicateTests: XCTestCase {

    func testExcludesAllDayEvents() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.isAllDay = true
        event.startDate = today(atHour: 9)
        event.endDate = today(atHour: 12)
        XCTAssertFalse(predicates.evaluate(with: event))
    }

    func testIncludesEventsWhereTheyBeginAfterTheBorderTimeAndEndAfterTheBorderTime() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.timeZone = TimeZone.current
        event.startDate = today(atHour: 9)
        event.endDate = today(atHour: 15)
        XCTAssertTrue(predicates.evaluate(with: event))
    }

    func testIncludesEventsFullyWithinTheBorder() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.timeZone = TimeZone.current
        event.startDate = today(atHour: 9)
        event.endDate = today(atHour: 11)
        XCTAssertTrue(predicates.evaluate(with: event))
    }

    func testIncludesEventsWhereTheyBeginBeforeTheBorderTimeAndEndBeforeTheBorderTime() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.timeZone = TimeZone.current
        event.startDate = today(atHour: 6)
        event.endDate = today(atHour: 9)
        XCTAssertTrue(predicates.evaluate(with: event))
    }

    func testIncludesEventsWhereTheyBeginBeforeTheBorderTimeAndEndAfterTheBorderTime() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.timeZone = TimeZone.current
        event.startDate = today(atHour: 7)
        event.endDate = today(atHour: 13)
        XCTAssertTrue(predicates.evaluate(with: event))
    }

    func testExcludesEventsWhereTheyBeginAfterTheBorderEnds() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.timeZone = TimeZone.current
        event.startDate = today(atHour: 13)
        event.endDate = today(atHour: 15)
        XCTAssertFalse(predicates.evaluate(with: event))
    }

    func testExcludesEventsWhereTheyEndBeforeTheBorderStarts() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.timeZone = TimeZone.current
        event.startDate = today(atHour: 3)
        event.endDate = today(atHour: 7)
        XCTAssertFalse(predicates.evaluate(with: event))
    }

    func testIncludesEventsWhereTheyFinishTheDayAfterButEarly() {
        let predicates = EventPredicates(timeRepository: TestTimeRepository()).standard()

        let event = EKEvent(eventStore: EKEventStore())
        event.timeZone = TimeZone.current
        event.startDate = today(atHour: 3)
        event.endDate = today(atHour: 3, addingDays: 1)
        XCTAssertTrue(predicates.evaluate(with: event))
    }

}

private func today(atHour hour: Int, minutes: Int = 0, addingDays days: Int = 0) -> Date {
    var components = Calendar.current.dateComponents([.day, .hour, .minute, .month, .year], from: Date())
    components.timeZone = .current
    components.minute = minutes
    components.hour = hour
    components.day = components.day.or(0) + days
    return Calendar.current.date(from: components)!
}

private class TestTimeRepository: NSObject, SCTimeRepository {

    func borderTimeStart() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: 8)
    }

    func borderTimeEnd() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: 12)
    }

}
