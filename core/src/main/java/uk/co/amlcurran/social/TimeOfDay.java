package uk.co.amlcurran.social;

import java.util.concurrent.TimeUnit;

import javax.annotation.Nonnull;

public class TimeOfDay {

    private final long millis;

    @Nonnull
    public static TimeOfDay fromHours(int hours) {
        return new TimeOfDay(TimeUnit.HOURS.toMillis(hours));
    }

    private TimeOfDay(long millis) {
        this.millis = millis;
    }

    public long toHours() {
        return TimeUnit.MILLISECONDS.toHours(millis);
    }

    public long toMinutes() {
        return TimeUnit.MILLISECONDS.toMinutes(millis);
    }
}
