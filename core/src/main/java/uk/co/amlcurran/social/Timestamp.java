package uk.co.amlcurran.social;

public class Timestamp {

    private final TimeCalculator timeCalculator;
    private final long millis;

    public Timestamp(long millis, TimeCalculator timeCalculator) {
        this.millis = millis;
        this.timeCalculator = timeCalculator;
    }

    public Timestamp plusDays(int days) {
        return timeCalculator.plusDays(days, this);
    }

    public int daysSinceEpoch() {
        return timeCalculator.getDays(this);
    }

    public long getMillis() {
        return millis;
    }

    public Timestamp plusHours(int hours) {
        return timeCalculator.plusHours(this, hours);
    }

}
