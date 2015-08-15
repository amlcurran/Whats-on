package uk.co.amlcurran.social;

class EventCalendarItem implements CalendarItem {
    private final long eventId;
    private final String title;
    private final long status;
    private final int startDay;

    public EventCalendarItem(long eventId, String title, long status, int startDay) {
        this.eventId = eventId;
        this.title = title;
        this.status = status;
        this.startDay = startDay;
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
    public boolean isEmpty() {
        return false;
    }
}
