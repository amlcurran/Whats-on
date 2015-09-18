package uk.co.amlcurran.social;

import java.util.List;

import rx.Observable;
import rx.Subscriber;
import rx.functions.Func1;
import uk.co.amlcurran.social.core.SparseArray;

public class EventsService {
    private final TimeRepository timeRepository;
    private final EventsRepository eventsRepository;

    public EventsService(TimeRepository dateCreator, EventsRepository eventsRepository) {
        this.eventsRepository = eventsRepository;
        this.timeRepository = dateCreator;
    }

    public Observable<CalendarSource> queryEventsFrom(Time now, final int numberOfDays) {
        return Observable.create(new Observable.OnSubscribe<EventRepositoryAccessor>() {
            @Override
            public void call(Subscriber<? super EventRepositoryAccessor> subscriber) {
                Time nowTime = timeRepository.startOfToday();
                Time nextWeek = nowTime.plusDays(numberOfDays);
                long fivePm = timeRepository.startOfBorderTimeInMinutes();
                long elevenPm = timeRepository.endOfBorderTimeInMinutes();

                EventRepositoryAccessor accessor = eventsRepository.queryEvents(subscriber, fivePm, elevenPm, nowTime, nextWeek);
                if (accessor == null) return;

                while (accessor.nextItem()) {
                    subscriber.onNext(accessor);
                }
                subscriber.onCompleted();
                accessor.endAccess();
            }
        })
                .map(convertToItem())
                .toList()
                .map(convertToSource(now, numberOfDays));
    }

    private static Func1<EventRepositoryAccessor, CalendarItem> convertToItem() {
        return new Func1<EventRepositoryAccessor, CalendarItem>() {
            @Override
            public CalendarItem call(EventRepositoryAccessor accessor) {
                String title = accessor.getTitle();
                long eventId = Long.valueOf(accessor.getEventIdentifier());
                long startTime = accessor.getDtStart();
                Time time = accessor.getStartTime();
                return new EventCalendarItem(eventId, title, startTime, time);
            }
        };
    }

    static Func1<List<CalendarItem>, CalendarSource> convertToSource(final Time now, final int size) {
        return new Func1<List<CalendarItem>, CalendarSource>() {
            @Override
            public CalendarSource call(List<CalendarItem> calendarItems) {
                SparseArray<CalendarItem> itemArray = new SparseArray<>(size);
                int epochToNow = now.daysSinceEpoch();
                for (CalendarItem item : calendarItems) {
                    itemArray.put(item.startDay() - epochToNow, item);
                }
                return new CalendarSource(itemArray, size, now);
            }
        };
    }

}
