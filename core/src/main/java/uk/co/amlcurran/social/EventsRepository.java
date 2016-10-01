package uk.co.amlcurran.social;

import java.util.List;

import javax.annotation.Nonnull;

public interface EventsRepository {

    @Nonnull
    List<CalendarItem> getCalendarItems(Timestamp nowTime, Timestamp nextWeek, TimeOfDay fivePm, TimeOfDay elevenPm, EventsService eventsService);
}
