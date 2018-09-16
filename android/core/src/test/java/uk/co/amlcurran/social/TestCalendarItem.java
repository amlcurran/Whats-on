package uk.co.amlcurran.social;

class TestCalendarItem implements CalendarItem {

    public TestCalendarItem() {
    }

    @Override
    public String title() {
        return "foo";
    }

    @Override
    public Timestamp startTime() {
        return new Timestamp(3000, new TestCalculator());
    }

    @Override
    public Timestamp endTime() {
        return new Timestamp(4000, new TestCalculator());
    }

    @Override
    public boolean isEmpty() {
        return false;
    }
}
