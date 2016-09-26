package uk.co.amlcurran.social;

import java.util.List;

public interface EventsRepository {

    List<CalendarItem> getCalendarItems(Timestamp nowTime, Timestamp nextWeek, TimeOfDay fivePm, TimeOfDay elevenPm, EventsService eventsService);
}
