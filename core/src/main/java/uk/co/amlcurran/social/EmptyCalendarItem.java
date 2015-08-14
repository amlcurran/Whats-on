package uk.co.amlcurran.social;

public class EmptyCalendarItem implements CalendarItem {
    private final int position;

    public EmptyCalendarItem(int position) {
        this.position = position;
    }

    @Override
    public String title() {
        return "Empty";
    }

    @Override
    public int startDay() {
        return position;
    }

    @Override
    public boolean isEmpty() {
        return true;
    }
}
