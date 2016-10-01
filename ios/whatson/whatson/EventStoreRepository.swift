import UIKit
import EventKit

@objc class EventStoreRepository: NSObject, SCEventsRepository {
    
    let calculator = NSDateCalculator()
    
    public func getCalendarItems(with nowTime: SCTimestamp!, with nextWeek: SCTimestamp!, with fivePm: SCTimeOfDay!, with elevenPm: SCTimeOfDay!, with eventsService: SCEventsService!) -> JavaUtilList {
        let eventStore = EKEventStore()
        let startTime = calculator.date(nowTime)
        let endTime = calculator.date(nextWeek)
        let search = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: nil)
        let allEvents = eventStore.events(matching: search)
        let filtered = allEvents.filter(EventPredicates.standardPredicates().evaluate)
        let items = filtered.flatMap({ ekEvent in
            return SCEventCalendarItem(nsString: ekEvent.eventIdentifier, with: ekEvent.title, with: self.calculator.time(ekEvent.startDate as NSDate), with: self.calculator.time(ekEvent.endDate as NSDate))
        })
        return items.toJavaList()
    }

}

fileprivate extension Array {
    
    func toJavaList() -> JavaUtilList {
        let list = JavaUtilArrayList()
        for item in self {
            list!.add(withId: item)
        }
        return list!
    }
    
}

/*
 
 EKEventStore *eventStore = [[EKEventStore alloc] init];
 NSDate *startTime =  [self.calculator date:nowTime];
 NSDate *endTime = [self.calculator date:nextWeek];
 NSPredicate *search = [eventStore predicateForEventsWithStartDate:startTime endDate:endTime calendars:nil];
 NSArray *array = [eventStore eventsMatchingPredicate:search];
 NSArray *filtered = [array filteredArrayUsingPredicate:self.predicate];
 id<JavaUtilList> items = [[JavaUtilArrayList alloc] init];
 for (EKEvent* item in filtered) {
 [items addWithId:[[SCEventCalendarItem alloc] initWithNSString:item.eventIdentifier
 withNSString:item.title
 withSCTimestamp:[self.calculator time:item.startDate]
 withSCTimestamp:[self.calculator time:item.endDate]]];
 }
 return items;
 */
