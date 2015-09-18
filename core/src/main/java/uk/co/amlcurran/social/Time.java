package uk.co.amlcurran.social;

import org.joda.time.DateTime;
import org.joda.time.Days;

public class Time {

    private final DateTime dateTime;

    public Time(DateTime dateTime) {
        this.dateTime = dateTime;
    }

    public Time plusDays(int days) {
        return new Time(dateTime.plusDays(days));
    }

    public int daysSinceEpoch() {
        return Days.daysBetween(CalendarItem.EPOCH, dateTime).getDays();
    }

    public long getMillis() {
        return dateTime.getMillis();
    }
}
