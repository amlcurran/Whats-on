package uk.co.amlcurran.social;

import java.util.List;

import javax.annotation.Nonnull;

import uk.co.amlcurran.social.core.SparseArray;

public class EventsService {
    private final TimeRepository timeRepository;
    private final EventsRepository eventsRepository;

    public EventsService(TimeRepository dateCreator, EventsRepository eventsRepository) {
        this.eventsRepository = eventsRepository;
        this.timeRepository = dateCreator;
    }

    @Nonnull
    public CalendarSource getCalendarSource(final int numberOfDays, final Timestamp now) {
        Timestamp nowTime = timeRepository.startOfToday();
        Timestamp nextWeek = nowTime.plusDays(numberOfDays);
        TimeOfDay fivePm = timeRepository.borderTimeStart();
        TimeOfDay elevenPm = timeRepository.borderTimeEnd();

        List<CalendarItem> calendarItems = eventsRepository.getCalendarItems(nowTime, nextWeek, fivePm, elevenPm, this);

        SparseArray<CalendarSlot> itemArray = new SparseArray<>(numberOfDays);
        int epochToNow = now.daysSinceEpoch();
        for (CalendarItem item : calendarItems) {
            int key = item.startTime().daysSinceEpoch() - epochToNow;
            CalendarSlot slot = itemArray.get(key, new CalendarSlot());
            slot.addItem(item);
            itemArray.put(key, slot);
        }

        return new CalendarSource(timeRepository, itemArray, numberOfDays);
    }

}
