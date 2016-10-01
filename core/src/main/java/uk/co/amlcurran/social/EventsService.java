package uk.co.amlcurran.social;

import java.util.List;

import javax.annotation.Nonnull;

import uk.co.amlcurran.social.core.SparseArray;

public class EventsService {
    private final TimeRepository timeRepository;
    private final EventsRepository eventsRepository;
    private final TimeCalculator timeCalculator;

    public EventsService(TimeRepository dateCreator, EventsRepository eventsRepository, TimeCalculator timeCalculator) {
        this.eventsRepository = eventsRepository;
        this.timeRepository = dateCreator;
        this.timeCalculator = timeCalculator;
    }

    @Nonnull
    public CalendarSource getCalendarSource(final int numberOfDays, final Timestamp now) {
        Timestamp nowTime = timeCalculator.startOfToday();
        Timestamp nextWeek = nowTime.plusDays(numberOfDays);
        TimeOfDay fivePm = timeRepository.borderTimeStart();
        TimeOfDay elevenPm = timeRepository.borderTimeEnd();

        List<CalendarItem> calendarItems = eventsRepository.getCalendarItems(nowTime, nextWeek, fivePm, elevenPm);

        SparseArray<CalendarSlot> itemArray = new SparseArray<>(numberOfDays);
        int epochToNow = now.daysSinceEpoch();
        for (CalendarItem item : calendarItems) {
            int key = item.startTime().daysSinceEpoch() - epochToNow;
            CalendarSlot slot = itemArray.get(key, new CalendarSlot());
            slot.addItem(item);
            itemArray.put(key, slot);
        }

        return new CalendarSource(itemArray, numberOfDays, timeCalculator);
    }

}
