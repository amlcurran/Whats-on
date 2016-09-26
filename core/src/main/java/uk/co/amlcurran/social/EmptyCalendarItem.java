package uk.co.amlcurran.social;

public class EmptyCalendarItem implements CalendarItem {

    private final Timestamp startTime;
    private final Timestamp endTime;

    public EmptyCalendarItem(Timestamp startTime, Timestamp endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
    }

    @Override
    public String title() {
        return "Empty";
    }

    @Override
    public Timestamp startTime() {
        return startTime;
    }

    @Override
    public Timestamp endTime() {
        return endTime;
    }

    @Override
    public boolean isEmpty() {
        return true;
    }
}
