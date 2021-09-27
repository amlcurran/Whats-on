package uk.co.amlcurran.social;

class TestCalendarItem implements CalendarItem {

    public TestCalendarItem() {
    }

    @Override
    public String getTitle() {
        return "foo";
    }

    @Override
    public Timestamp getStartTime() {
        return new Timestamp(3000, new TestCalculator());
    }

    @Override
    public Timestamp getEndTime() {
        return new Timestamp(4000, new TestCalculator());
    }

    @Override
    public boolean isEmpty() {
        return false;
    }
}
