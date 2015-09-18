package uk.co.amlcurran.social;

class EventCalendarItem implements CalendarItem {
    private final long eventId;
    private final String title;
    private final long startTime;
    private final Time start;

    public EventCalendarItem(long eventId, String title, long startTime, Time time) {
        this.eventId = eventId;
        this.title = title;
        this.startTime = startTime;
        this.start = time;
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
        return start.daysSinceEpoch();
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
