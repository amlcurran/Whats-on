package uk.co.amlcurran.social;

import org.joda.time.DateTime;

public class EmptyCalendarItem implements CalendarItem {
    private final int position;
    private final DateTime startTime;

    public EmptyCalendarItem(int position, DateTime startTime) {
        this.position = position;
        this.startTime = startTime;
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
    public long startTime() {
        return startTime.getMillis();
    }

    @Override
    public boolean isEmpty() {
        return true;
    }
}
