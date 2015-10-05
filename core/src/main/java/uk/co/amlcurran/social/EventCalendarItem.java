package uk.co.amlcurran.social;

class EventCalendarItem implements CalendarItem {
    private final String eventId;
    private final String title;
    private final Time start;
    private final Time endTime;

    public EventCalendarItem(String eventId, String title, Time time, Time endTime) {
        this.eventId = eventId;
        this.title = title;
        this.start = time;
        this.endTime = endTime;
    }

    public String id() {
        return eventId;
    }

    @Override
    public String title() {
        return title;
    }

    @Override
    public Time startTime() {
        return start;
    }

    @Override
    public Time endTime() {
        return endTime;
    }

    @Override
    public boolean isEmpty() {
        return false;
    }
}
