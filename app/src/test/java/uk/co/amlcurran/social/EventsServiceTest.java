package uk.co.amlcurran.social;

import org.junit.Test;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

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

    private static class TestAccessor implements EventRepositoryAccessor {

        private final List<String> eventIds;
        private int currentPosition = -1;

        private TestAccessor(List<String> eventIds) {
            this.eventIds = eventIds;
        }

        @Override
        public String getTitle() {
            return "Test title";
        }

        @Override
        public String getEventIdentifier() {
            return eventIds.get(currentPosition);
        }

        @Override
        public boolean nextItem() {
            currentPosition++;
            return currentPosition < eventIds.size();
        }

        @Override
        public void endAccess() {

        }

        @Override
        public Time getStartTime() {
            return new TestTime(17 * 60 * 60 * 1000);
        }

        @Override
        public Time getEndTime() {
            return new TestTime(19 * 60 * 60 * 1000);
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

    private static class TestTime implements Time {

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
}