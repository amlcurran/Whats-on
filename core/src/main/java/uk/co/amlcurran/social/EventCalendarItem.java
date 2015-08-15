package uk.co.amlcurran.social;

class EventCalendarItem implements CalendarItem {
    private final long eventId;
    private final String title;
    private final long status;
    private final int startDay;
    private final long startTime;

    public EventCalendarItem(long eventId, String title, long status, int startDay, long startTime) {
        this.eventId = eventId;
        this.title = title;
        this.status = status;
        this.startDay = startDay;
        this.startTime = startTime;
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
        return startDay;
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
