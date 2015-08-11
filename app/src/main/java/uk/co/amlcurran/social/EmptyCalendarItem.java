package uk.co.amlcurran.social;

public class EmptyCalendarItem implements CalendarItem {
    @Override
    public String title() {
        return "Empty";
    }

    @Override
    public int startDay() {
        return 0;
    }

    @Override
    public boolean isEmpty() {
        return true;
    }
}
