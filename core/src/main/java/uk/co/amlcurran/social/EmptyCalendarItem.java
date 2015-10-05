package uk.co.amlcurran.social;

public class EmptyCalendarItem implements CalendarItem {

    private final Time startTime;
    private final Time endTime;

    public EmptyCalendarItem(Time startTime, Time endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
    }

    @Override
    public String title() {
        return "Empty";
    }

    @Override
    public Time startTime() {
        return startTime;
    }

    @Override
    public Time endTime() {
        return endTime;
    }

    @Override
    public boolean isEmpty() {
        return true;
    }
}
