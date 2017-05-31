package uk.co.amlcurran.social;

import java.util.concurrent.TimeUnit;

import javax.annotation.Nonnull;

public class TimeOfDay {

    private final long millis;

    @Nonnull
    public static TimeOfDay fromHours(int hours) {
        return new TimeOfDay(TimeUnit.HOURS.toMillis(hours));
    }

    @Nonnull
    public static TimeOfDay fromHoursAndMinute(int hours, int minutes) {
        return new TimeOfDay(TimeUnit.HOURS.toMillis(hours) + TimeUnit.MINUTES.toMillis(minutes));
    }

    private TimeOfDay(long millis) {
        this.millis = millis;
    }

    public long hoursInDay() {
        return TimeUnit.MILLISECONDS.toHours(millis);
    }

    public long minutesInDay() {
        return TimeUnit.MILLISECONDS.toMinutes(millis);
    }
}
