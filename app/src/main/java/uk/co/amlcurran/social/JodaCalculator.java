package uk.co.amlcurran.social;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.Days;

class JodaCalculator implements TimeCalculator {
    private static final DateTime EPOCH = new DateTime(0, DateTimeZone.getDefault());

    @Override
    public Time plusHours(Time time, int hours) {
        return new Time(getDateTime(time).plusHours(hours).getMillis(), this);
    }

    @Override
    public int getDays(Time time) {
        return Days.daysBetween(EPOCH, getDateTime(time)).getDays();
    }

    @Override
    public Time plusDays(int days, Time time) {
        return new Time(getDateTime(time).plusDays(days).getMillis(), this);
    }

    private DateTime getDateTime(Time time) {
        return new DateTime(time.getMillis(), DateTimeZone.getDefault());
    }
}
