package uk.co.amlcurran.social;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.Days;

public class JodaTime implements Time {

    private static final DateTime EPOCH = new DateTime(0, DateTimeZone.getDefault());
    private final DateTime dateTime;

    public JodaTime(DateTime dateTime) {
        this.dateTime = dateTime;
    }

    @Override
    public Time plusDays(int days) {
        return new JodaTime(dateTime.plusDays(days));
    }

    @Override
    public int daysSinceEpoch() {
        return Days.daysBetween(EPOCH, dateTime).getDays();
    }

    @Override
    public long getMillis() {
        return dateTime.getMillis();
    }
}
