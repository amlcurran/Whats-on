package uk.co.amlcurran.social;

public class CalendarSourceTests {

//    @Test
//    public void testOneDayWithNoItemsIsEmpty() {
//        List<CalendarItem> items = new ArrayList<>();
//        CalendarSource calendarSource = WhatsOnActivity.convertToSource(1).call(items);
//
//        assertThat(calendarSource.isEmptyAt(0)).isTrue();
//    }
//
//    @Test
//    public void testOneDayWithOneItemIsNotEmpty() {
//        List<CalendarItem> items = new ArrayList<>();
//        items.add(new TestCalendarItem(0));
//        CalendarSource calendarSource = WhatsOnActivity.convertToSource(1).call(items);
//
//        assertThat(calendarSource.isEmptyAt(0)).isFalse();
//    }
//
//    @Test
//    public void testTwoDaysWithOneItemOnDayTwoIsEmptyOnDayOne() {
//        List<CalendarItem> items = new ArrayList<>();
//        items.add(new TestCalendarItem(1));
//        CalendarSource calendarSource = WhatsOnActivity.convertToSource(2).call(items);
//
//        assertThat(calendarSource.isEmptyAt(0)).isTrue();
//    }
//
//    @Test
//    public void testTwoDaysWithNegativeStartDayItemOnDayOneIsEmptyOnDayTwo() {
//        List<CalendarItem> items = new ArrayList<>();
//        items.add(new TestCalendarItem(-1));
//        CalendarSource calendarSource = WhatsOnActivity.convertToSource(2).call(items);
//
//        assertThat(calendarSource.isEmptyAt(0)).isFalse();
//    }
//
//    @Test
//    public void testOneDayWithALargeStartDayIsNotEmptyOnDayOne() {
//        List<CalendarItem> items = new ArrayList<>();
//        items.add(new TestCalendarItem(30020));
//        CalendarSource calendarSource = WhatsOnActivity.convertToSource(1).call(items);
//
//        assertThat(calendarSource.isEmptyAt(0)).isFalse();
//    }
//
//    private static class TestCalendarItem implements CalendarItem {
//        private final int startDay;
//
//        public TestCalendarItem(int startDay) {
//            this.startDay = startDay;
//        }
//
//        @Override
//        public String title() {
//            return null;
//        }
//
//        @Override
//        public int startDay() {
//            return startDay;
//        }
//
//        @Override
//        public boolean isEmpty() {
//            return false;
//        }
//    }
}