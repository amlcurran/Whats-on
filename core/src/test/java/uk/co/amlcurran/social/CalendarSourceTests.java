package uk.co.amlcurran.social;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.fest.assertions.api.Assertions.assertThat;

public class CalendarSourceTests {

    @Test
    public void testOneDayWithNoItemsIsEmpty() {
        List<CalendarItem> items = new ArrayList<>();
        CalendarSource calendarSource = getSource(items, 1);

        assertThat(calendarSource.slotAt(0).isEmpty()).isTrue();
    }

    private CalendarSource getSource(List<CalendarItem> items, int numberOfItems) {
        return null;
    }

    @Test
    public void testOneDayWithOneItemIsNotEmpty() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem(0));
        CalendarSource calendarSource = getSource(items, 1);

        assertThat(calendarSource.slotAt(0).isEmpty()).isFalse();
    }

    @Test
    public void testTwoDaysWithOneItemOnDayTwoIsEmptyOnDayOne() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem(1));
        CalendarSource calendarSource = getSource(items, 2);

        assertThat(calendarSource.slotAt(0).isEmpty()).isTrue();
    }

    @Test
    public void testTwoDaysWithNegativeStartDayItemOnDayOneIsEmptyOnDayTwo() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem(-1));
        CalendarSource calendarSource = getSource(items, 2);

        assertThat(calendarSource.slotAt(0).isEmpty()).isFalse();
    }

    @Test
    public void testOneDayWithALargeStartDayIsNotEmptyOnDayOne() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem(30020));
        CalendarSource calendarSource = getSource(items, 1);

        assertThat(calendarSource.slotAt(0).isEmpty()).isFalse();
    }

    private static class TestCalendarItem implements CalendarItem {
        private final int startDay;

        public TestCalendarItem(int startDay) {
            this.startDay = startDay;
        }

        @Override
        public String title() {
            return null;
        }

        @Override
        public Time startTime() {
            return null;
        }

        @Override
        public Time endTime() {
            return null;
        }

        @Override
        public int startDay() {
            return startDay;
        }

        @Override
        public boolean isEmpty() {
            return false;
        }
    }
}