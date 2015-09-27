package uk.co.amlcurran.social;

import java.util.ArrayList;
import java.util.List;

import uk.co.amlcurran.social.core.SparseArray;

public class EventsService {
    private final TimeRepository timeRepository;
    private final EventsRepository eventsRepository;

    public EventsService(TimeRepository dateCreator, EventsRepository eventsRepository) {
        this.eventsRepository = eventsRepository;
        this.timeRepository = dateCreator;
    }

    public CalendarSource getCalendarSource(final int numberOfDays, final Time now) {
        Time nowTime = timeRepository.startOfToday();
        Time nextWeek = nowTime.plusDays(numberOfDays);
        long fivePm = timeRepository.startOfBorderTimeInMinutes();
        long elevenPm = timeRepository.endOfBorderTimeInMinutes();

        EventRepositoryAccessor accessor = eventsRepository.queryEvents(fivePm, elevenPm, nowTime, nextWeek);
        List<CalendarItem> calendarItems = new ArrayList<>();
        while (accessor.nextItem()) {
            String title = accessor.getTitle();
            String eventId = accessor.getEventIdentifier();
            long startTime = accessor.getDtStart();
            Time time = accessor.getStartTime();
            calendarItems.add(new EventCalendarItem(eventId, title, startTime, time));
        }

        SparseArray<CalendarItem> itemArray = new SparseArray<>(numberOfDays);
        int epochToNow = now.daysSinceEpoch();
        for (CalendarItem item : calendarItems) {
            itemArray.put(item.startDay() - epochToNow, item);
        }

        CalendarSource calendarSource = new CalendarSource(itemArray, numberOfDays, now);
        accessor.endAccess();
        return calendarSource;
    }

}
