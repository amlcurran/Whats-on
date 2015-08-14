package uk.co.amlcurran.social;

class EventCalendarItem implements CalendarItem {
    private final String title;
    private final long status;
    private final int startDay;

    public EventCalendarItem(String title, long status, int startDay) {
        this.title = title;
        this.status = status;
        this.startDay = startDay;
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
