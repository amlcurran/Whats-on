package uk.co.amlcurran.social;

import java.util.concurrent.TimeUnit;

class TestTime implements Time {

    private final long millis;

    public TestTime(long millis) {
        this.millis = millis;
    }

    @Override
    public Time plusDays(int days) {
        return new TestTime(millis + TimeUnit.DAYS.toMillis(days));
    }

    @Override
    public int daysSinceEpoch() {
        return (int) TimeUnit.MILLISECONDS.toDays(millis);
    }

    @Override
    public long getMillis() {
        return millis;
    }

    @Override
    public Time plusHours(int hours) {
        throw new UnsupportedOperationException("Test time does not implement this");
    }
}
