package uk.co.amlcurran.social;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.provider.CalendarContract;

public class AndroidEventsRepository implements EventsRepository {

    private static String[] PROJECTION = new String[]{
            CalendarContract.Events.TITLE,
            CalendarContract.Instances.START_DAY,
            CalendarContract.Events.SELF_ATTENDEE_STATUS,
            CalendarContract.Events.DTSTART,
            CalendarContract.Instances.EVENT_ID
    };
    private final ContentResolver contentResolver;

    public AndroidEventsRepository(ContentResolver contentResolver) {
        this.contentResolver = contentResolver;
    }

    @Override
    public EventRepositoryAccessor queryEvents(TimeOfDay fivePm, TimeOfDay elevenPm,
                                               Time searchStart, Time searchEnd) {
        Uri.Builder builder = CalendarContract.Instances.CONTENT_URI.buildUpon();
        ContentUris.appendId(builder, searchStart.getMillis());
        ContentUris.appendId(builder, searchEnd.getMillis());

        String endsBefore = String.format("%1$s < %2$d", CalendarContract.Instances.END_MINUTE, fivePm.toMinutes());
        String startsAfter = String.format("%1$s > %2$d", CalendarContract.Instances.START_MINUTE, elevenPm.toMinutes());
        String selection = String.format("(NOT (%1$s OR %2$s)) AND %3$s <> %4$d AND %5$s == %6$d",
                endsBefore, startsAfter,
                CalendarContract.Instances.SELF_ATTENDEE_STATUS, CalendarContract.Instances.STATUS_CANCELED,
                CalendarContract.Instances.ALL_DAY, 0);

        Cursor calendarCursor = contentResolver.query(builder.build(), PROJECTION, selection, null, null);
        return new CursorEventRepositoryAccessor(calendarCursor, new JodaCalculator());
    }

    private static class CursorEventRepositoryAccessor implements EventRepositoryAccessor {

        private final Cursor calendarCursor;
        private final int titleColumnIndex;
        private final int dtStartColumnIndex;
        private final int dtEndColumnIndex;
        private final int eventIdColumnIndex;
        private final TimeCalculator timeCalculator;

        public CursorEventRepositoryAccessor(Cursor calendarCursor, TimeCalculator timeCalculator) {
            this.calendarCursor = calendarCursor;
            this.titleColumnIndex = calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.TITLE);
            this.dtStartColumnIndex = calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DTSTART);
            this.dtEndColumnIndex = calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DTEND);
            this.eventIdColumnIndex = calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.EVENT_ID);
            this.timeCalculator = timeCalculator;
        }

        @Override
        public String getTitle() {
            return calendarCursor.getString(titleColumnIndex);
        }

        @Override
        public String getEventIdentifier() {
            return calendarCursor.getString(eventIdColumnIndex);
        }

        @Override
        public boolean nextItem() {
            return calendarCursor.moveToNext();
        }

        @Override
        public void endAccess() {
            calendarCursor.close();
        }

        @Override
        public Time getStartTime() {
            long startMillis = calendarCursor.getLong(dtStartColumnIndex);
            return new Time(startMillis, timeCalculator);
        }

        @Override
        public Time getEndTime() {
            long endMillis = calendarCursor.getLong(dtEndColumnIndex);
            return new Time(endMillis, timeCalculator);
        }
    }

}
