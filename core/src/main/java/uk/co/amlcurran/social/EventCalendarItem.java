package uk.co.amlcurran.social;

class EventCalendarItem implements CalendarItem {
    private final String eventId;
    private final String title;
    private final Time start;

    public EventCalendarItem(String eventId, String title, Time time) {
        this.eventId = eventId;
        this.title = title;
        this.start = time;
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
    public boolean isEmpty() {
        return false;
    }
}
