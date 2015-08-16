package uk.co.amlcurran.social;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.Days;

class EventCalendarItem implements CalendarItem {
    private final long eventId;
    private final String title;
    private final long startTime;
    private final DateTime start;

    public EventCalendarItem(long eventId, String title, long startTime) {
        this.eventId = eventId;
        this.title = title;
        this.startTime = startTime;
        this.start = new DateTime(startTime, DateTimeZone.getDefault());
    }

    public long id() {
        return eventId;
    }

    @Override
    public String title() {
        return title;
    }

    @Override
    public int startDay() {
        return Days.daysBetween(EPOCH, start).getDays();
    }

    @Override
    public long startTime() {
        return startTime;
    }

    @Override
    public boolean isEmpty() {
        return false;
    }
}
