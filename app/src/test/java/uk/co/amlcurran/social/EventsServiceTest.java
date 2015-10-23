package uk.co.amlcurran.social;

import org.junit.Test;

import java.util.Arrays;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;

public class EventsServiceTest {

    @Test
    public void givenASlotWithTwoEventsThenTheSlotHasACountOfTwo() {
        EventsService service = new EventsService(new MyTimeRepository(), new MyEventsRepository());

        CalendarSource calendarSource = service.getCalendarSource(14, new TestTime(0));

        assertThat(calendarSource.slotAt(0).count(), is(2));
    }

    private static class MyEventsRepository implements EventsRepository {
        @Override
        public EventRepositoryAccessor queryEvents(long fivePm, long elevenPm, Time searchStartTime, Time searchEndTime) {
            return new TestAccessor(Arrays.asList("event1", "event2"));
        }

    }

    private static class MyTimeRepository implements TimeRepository {
        @Override
        public int endOfBorderTimeInMinutes() {
            return 23 * 60;
        }

        @Override
        public int startOfBorderTimeInMinutes() {
            return 17 * 60;
        }

        @Override
        public Time startOfToday() {
            return new TestTime(0);
        }
    }

}