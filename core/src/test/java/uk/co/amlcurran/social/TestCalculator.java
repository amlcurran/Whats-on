package uk.co.amlcurran.social;

class TestCalculator implements TimeCalculator {
    @Override
    public Timestamp plusDays(int days, Timestamp time) {
        return null;
    }

    @Override
    public int getDays(Timestamp time) {
        return 0;
    }

    @Override
    public Timestamp plusHours(Timestamp time, int hours) {
        return null;
    }

    @Override
    public Timestamp startOfToday() {
        return null;
    }
}
