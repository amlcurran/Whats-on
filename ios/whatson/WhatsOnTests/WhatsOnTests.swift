import XCTest
@testable import What_s_On

class WhatsOnTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}

/*
 
 EKEventStore *eventStore = [[EKEventStore alloc] init];
 NSDate *startTime =  [self.calculator date:searchStartTime];
 NSDate *endTime = [self.calculator date:searchEndTime];
 NSPredicate *search = [eventStore predicateForEventsWithStartDate:startTime endDate:endTime calendars:nil];
 NSArray *array = [eventStore eventsMatchingPredicate:search];
 __block NSCalendar *calendar = self.calendar;
 NSArray *filtered = [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
 EKEvent *event = (EKEvent *) evaluatedObject;
 NSDateComponents *endComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitDay fromDate:event.endDate];
 endComponents.timeZone = [NSTimeZone defaultTimeZone];
 NSDateComponents *startComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitDay fromDate:event.startDate];
 startComponents.timeZone = [NSTimeZone defaultTimeZone];
 bool endsBefore = endComponents.hour <= 18 && endComponents.day == startComponents.day;
 bool startsAfter = startComponents.hour > 23;
 return !(endsBefore || startsAfter) && event.allDay == false;
 }]];
 return [[SCIEKEventAccessor alloc] initWithEventItems:filtered];
 
 */
