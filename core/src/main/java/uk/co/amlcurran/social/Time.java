package uk.co.amlcurran.social;

public class Time {

    private final TimeCalculator timeCalculator;
    private final long millis;

    public Time(long millis, TimeCalculator timeCalculator) {
        this.millis = millis;
        this.timeCalculator = timeCalculator;
    }

    public Time plusDays(int days) {
        return timeCalculator.plusDays(days, this);
    }

    public int daysSinceEpoch() {
        return timeCalculator.getDays(this);
    }

    public long getMillis() {
        return millis;
    }

    public Time plusHours(int hours) {
        return timeCalculator.plusHours(this, hours);
    }

}
