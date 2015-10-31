package uk.co.amlcurran.social;

import java.util.concurrent.TimeUnit;

public class TimeOfDay {

    private final long millis;

    public static TimeOfDay fromHours(int hours) {
        return new TimeOfDay(TimeUnit.HOURS.toMillis(hours));
    }

    private TimeOfDay(long millis) {
        this.millis = millis;
    }

    public long toMinutes() {
        return TimeUnit.MILLISECONDS.toMinutes(millis);
    }
}
