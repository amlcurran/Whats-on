package uk.co.amlcurran.social;

import android.support.v4.util.SparseArrayCompat;

import org.joda.time.DateTime;

import java.util.List;

import rx.Observable;
import rx.Subscriber;
import rx.functions.Func1;
import uk.co.amlcurran.social.core.ItemSource;

public class EventsService {
    private final DateCreator dateCreator;
    private final EventsRepository eventsRepository;

    public EventsService(DateCreator dateCreator, EventsRepository eventsRepository) {
        this.eventsRepository = eventsRepository;
        this.dateCreator = dateCreator;
    }

    public Observable<ItemSource<CalendarItem>> queryEventsFrom(final DateTime now, final int numberOfDays) {
        return Observable.create(new Observable.OnSubscribe<EventRepositoryAccessor>() {
            @Override
            public void call(Subscriber<? super EventRepositoryAccessor> subscriber) {
                Time nowTime = dateCreator.startOfToday(now);
                Time nextWeek = nowTime.plusDays(numberOfDays);
                long fivePm = dateCreator.startOfBorderTimeInMinutes();
                long elevenPm = dateCreator.endOfBorderTimeInMinutes();

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
                .map(convertToSource(new Time(now), numberOfDays));
    }

    private static Func1<EventRepositoryAccessor, CalendarItem> convertToItem() {
        return new Func1<EventRepositoryAccessor, CalendarItem>() {
            @Override
            public CalendarItem call(EventRepositoryAccessor accessor) {
                String title = accessor.getTitle();
                long startTime = accessor.getDtStart();
                long eventId = Long.valueOf(accessor.getEventIdentifier());
                return new EventCalendarItem(eventId, title, startTime);
            }
        };
    }

    static Func1<List<CalendarItem>, ItemSource<CalendarItem>> convertToSource(final Time now, final int size) {
        return new Func1<List<CalendarItem>, ItemSource<CalendarItem>>() {
            @Override
            public ItemSource<CalendarItem> call(List<CalendarItem> calendarItems) {
                SparseArrayCompat<CalendarItem> itemArray = new SparseArrayCompat<>();
                int epochToNow = now.daysSinceEpoch();
                for (CalendarItem item : calendarItems) {
                    itemArray.put(item.startDay() - epochToNow, item);
                }
                return new CalendarSource(itemArray, size, now);
            }
        };
    }

}
