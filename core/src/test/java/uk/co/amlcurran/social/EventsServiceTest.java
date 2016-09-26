package uk.co.amlcurran.social;

import org.junit.Test;

import java.util.Arrays;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;

public class EventsServiceTest {

    @Test
    public void givenASlotWithTwoEventsThenTheSlotHasACountOfTwo() {
        EventsService service = new EventsService(new MyTimeRepository(), new MyEventsRepository());

        CalendarSource calendarSource = service.getCalendarSource(14, new Timestamp(0, new TestCalculator()));

        assertThat(calendarSource.slotAt(0).count(), is(2));
    }

    private static class MyEventsRepository implements EventsRepository {
        @Override
        public EventRepositoryAccessor queryEvents(TimeOfDay fivePm, TimeOfDay elevenPm, Timestamp searchStartTime, Timestamp searchEndTime) {
            return new TestAccessor(Arrays.asList("event1", "event2"));
        }

    }

    private static class MyTimeRepository implements TimeRepository {
        @Override
        public TimeOfDay borderTimeEnd() {
            return TimeOfDay.fromHours(23);
        }

        @Override
        public TimeOfDay borderTimeStart() {
            return TimeOfDay.fromHours(17);
        }

        @Override
        public Timestamp startOfToday() {
            return new Timestamp(0, new TestCalculator());
        }
    }

}