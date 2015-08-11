package uk.co.amlcurran.social;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.fest.assertions.api.Assertions.assertThat;

public class CalendarSourceTests {

    @Test
    public void testOneDayWithNoItemsIsEmpty() {
        List<CalendarItem> items = new ArrayList<>();
        CalendarSource calendarSource = WhatsOnActivity.convertToSource(1).call(items);

        assertThat(calendarSource.isEmptyAt(0)).isTrue();
    }

    @Test
    public void testOneDayWithOneItemIsNotEmpty() {
        List<CalendarItem> items = new ArrayList<>();
        items.add(new TestCalendarItem());
        CalendarSource calendarSource = WhatsOnActivity.convertToSource(1).call(items);

        assertThat(calendarSource.isEmptyAt(0)).isFalse();
    }

    private static class TestCalendarItem implements CalendarItem {
        @Override
        public String title() {
            return null;
        }

        @Override
        public long startDay() {
            return 0;
        }

        @Override
        public boolean isEmpty() {
            return false;
        }
    }
}