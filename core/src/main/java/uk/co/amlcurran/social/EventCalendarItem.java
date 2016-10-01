package uk.co.amlcurran.social;

import javax.annotation.Nonnull;

class EventCalendarItem implements CalendarItem {
    private final String eventId;
    private final String title;
    private final Timestamp start;
    private final Timestamp endTime;

    public EventCalendarItem(String eventId, String title, Timestamp time, Timestamp endTime) {
        this.eventId = eventId;
        this.title = title;
        this.start = time;
        this.endTime = endTime;
    }

    public String id() {
        return eventId;
    }

    @Nonnull
    @Override
    public String title() {
        return title;
    }

    @Nonnull
    @Override
    public Timestamp startTime() {
        return start;
    }

    @Nonnull
    @Override
    public Timestamp endTime() {
        return endTime;
    }

    @Override
    public boolean isEmpty() {
        return false;
    }
}
