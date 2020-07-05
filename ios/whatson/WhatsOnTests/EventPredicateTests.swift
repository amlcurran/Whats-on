import XCTest
import EventKit
import Core
@testable import Whatson

class EventPredicateTests: XCTestCase {

//    let predicates = EventPredicates(timeRepository: TestTimeRepository()).defaults
//
//    func testExcludesAllDayEvents() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.isAllDay = true
//        event.startDate = today(atHour: 9)
//        event.endDate = today(atHour: 12)
//        XCTAssertFalse(predicates(event))
//    }
//
//    func testIncludesEventsWhereTheyBeginAfterTheBorderTimeAndEndAfterTheBorderTime() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 9)
//        event.endDate = today(atHour: 15)
//        XCTAssertTrue(predicates(event))
//    }
//
//    func testIncludesEventsFullyWithinTheBorder() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 9)
//        event.endDate = today(atHour: 11)
//        XCTAssertTrue(predicates(event))
//    }
//
//    func testIncludesEventsExactlyOnTheBorder() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 8)
//        event.endDate = today(atHour: 12)
//        XCTAssertTrue(predicates(event))
//    }
//
//    func testIncludesEventsWhereTheyBeginBeforeTheBorderTimeAndEndBeforeTheBorderTime() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 6)
//        event.endDate = today(atHour: 9)
//        XCTAssertTrue(predicates(event))
//    }
//
//    func testIncludesEventsWhereTheyBeginBeforeTheBorderTimeAndEndAfterTheBorderTime() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 7)
//        event.endDate = today(atHour: 13)
//        XCTAssertTrue(predicates(event))
//    }
//
//    func testExcludesEventsWhereTheyBeginAfterTheBorderEnds() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 13)
//        event.endDate = today(atHour: 15)
//        XCTAssertFalse(predicates(event))
//    }
//
//    func testExcludesEventsWhereTheyEndBeforeTheBorderStarts() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 3)
//        event.endDate = today(atHour: 7)
//        XCTAssertFalse(predicates(event))
//    }
//
//    func testIncludesEventsWhereTheyFinishTheDayAfterButEarly() {
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 3)
//        event.endDate = today(atHour: 3, addingDays: 1)
//        XCTAssertTrue(predicates(event))
//    }
//
//    func testIncludesEventsWithABorderWithMinutes() {
//        let predicates = EventPredicates(timeRepository: TestTimeRepositoryWithMinutes()).defaults
//
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 23, minutes: 45)
//        event.endDate = today(atHour: 8, minutes: 50, addingDays: 1)
//        XCTAssertTrue(predicates(event))
//    }
//
//    func testExcludesEventsWithABorderWithMinutesJustAfterTheBoundary() {
//        let predicates = EventPredicates(timeRepository: TestTimeRepositoryWithMinutes()).defaults
//
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 23, minutes: 59)
//        event.endDate = today(atHour: 8, minutes: 50, addingDays: 1)
//        XCTAssertFalse(predicates(event))
//    }
//
//    func testExcludesEventsWithABorderWithMinutesJustBeforeTheBoundary() {
//        let predicates = EventPredicates(timeRepository: TestTimeRepositoryWithMinutes2()).defaults
//
//        let event = EKEvent(eventStore: EKEventStore())
//        event.timeZone = TimeZone.current
//        event.startDate = today(atHour: 21, minutes: 10)
//        event.endDate = today(atHour: 22, minutes: 25)
//        XCTAssertFalse(predicates(event))
//    }

}

private func today(atHour hour: Int, minutes: Int = 0, addingDays days: Int = 0) -> Date {
    var components = Calendar.current.dateComponents([.day, .hour, .minute, .month, .year], from: Date())
    components.timeZone = .current
    components.minute = minutes
    components.hour = hour
    components.day = components.day.or(0) + days
    return Calendar.current.date(from: components)!
}

private class TestTimeRepository: BorderTimeRepository {

    var borderTimeStart: TimeOfDay {
        return TimeOfDay.fromHours(hours: 8)
    }

    var borderTimeEnd: TimeOfDay {
        return TimeOfDay.fromHours(hours: 12)
    }

}

private class TestTimeRepositoryWithMinutes: BorderTimeRepository {

    var borderTimeStart: TimeOfDay {
        return TimeOfDay.fromHours(hours: 22, andMinutes: 0)
    }

    var borderTimeEnd: TimeOfDay {
        return TimeOfDay.fromHours(hours: 23, andMinutes: 58)
    }

}

private class TestTimeRepositoryWithMinutes2: BorderTimeRepository {

    var borderTimeStart: TimeOfDay {
        return TimeOfDay.fromHours(hours: 22, andMinutes: 30)
    }

    var borderTimeEnd: TimeOfDay {
        return TimeOfDay.fromHours(hours: 23, andMinutes: 59)
    }

}
