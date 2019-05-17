package uk.co.amlcurran.social;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.Days;

class JodaCalculator implements TimeCalculator {
    private static final DateTime EPOCH = new DateTime(0, DateTimeZone.getDefault());

    @Override
    public Timestamp plusHours(Timestamp time, int hours) {
        return new Timestamp(getDateTime(time).plusHours(hours).getMillis(), this);
    }

    @Override
    public Timestamp startOfToday() {
        return new Timestamp(DateTime.now().withTimeAtStartOfDay().getMillis(), this);
    }

    @Override
    public int getDays(Timestamp time) {
        return Days.daysBetween(EPOCH, getDateTime(time)).getDays();
    }

    @Override
    public Timestamp plusDays(int days, Timestamp time) {
        return new Timestamp(getDateTime(time).plusDays(days).getMillis(), this);
    }

    DateTime getDateTime(Timestamp time) {
        return new DateTime(time.getMillis(), DateTimeZone.getDefault());
    }
}
