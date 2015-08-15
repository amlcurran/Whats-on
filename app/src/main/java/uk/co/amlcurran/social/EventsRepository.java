package uk.co.amlcurran.social;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.provider.CalendarContract;
import android.support.v4.util.SparseArrayCompat;

import org.joda.time.DateTime;

import java.util.List;

import rx.Observable;
import rx.Subscriber;
import rx.functions.Func1;
import uk.co.amlcurran.social.bootstrap.ItemSource;

public class EventsRepository {
    private static String[] PROJECTION = new String[]{
            CalendarContract.Events.TITLE,
            CalendarContract.Instances.START_DAY,
            CalendarContract.Events.SELF_ATTENDEE_STATUS,
            CalendarContract.Events.DTSTART,
            CalendarContract.Instances.EVENT_ID
    };
    private final ContentResolver contentResolver;

    public EventsRepository(ContentResolver contentResolver) {
        this.contentResolver = contentResolver;
    }

    public Observable<ItemSource<CalendarItem>> queryEventsFrom(final DateTime now, final int numberOfDays) {
        return Observable.create(new Observable.OnSubscribe<Cursor>() {
            @Override
            public void call(Subscriber<? super Cursor> subscriber) {
                long nowMillis = now.withTimeAtStartOfDay().getMillis();
                long nextWeek = now.withTimeAtStartOfDay().plusDays(numberOfDays).getMillis();

                Uri.Builder builder = CalendarContract.Instances.CONTENT_URI.buildUpon();
                ContentUris.appendId(builder, nowMillis);
                ContentUris.appendId(builder, nextWeek);

                long fivePm = 17 * 60;
                long elevenPm = 23 * 60;

                String selection = String.format("%1$s >= %2$d AND %3$s <= %4$d AND %5$s <> %6$d",
                        CalendarContract.Instances.START_MINUTE, fivePm,
                        CalendarContract.Instances.END_MINUTE, elevenPm,
                        CalendarContract.Instances.SELF_ATTENDEE_STATUS, CalendarContract.Instances.STATUS_CANCELED);

                Cursor calendarCursor = contentResolver.query(builder.build(), PROJECTION, selection, null, null);
                if (calendarCursor == null) {
                    subscriber.onError(new NullPointerException("Calendar cursor was null!"));
                    return;
                }

                while (calendarCursor.moveToNext()) {
                    subscriber.onNext(calendarCursor);
                }
                subscriber.onCompleted();
                calendarCursor.close();
            }
        })
                .map(convertToItem())
                .toList()
                .map(convertToSource(now, numberOfDays));
    }

    private static Func1<Cursor, CalendarItem> convertToItem() {
        return new Func1<Cursor, CalendarItem>() {
            @Override
            public CalendarItem call(Cursor cursor) {
                String title = cursor.getString(cursor.getColumnIndex(CalendarContract.Events.TITLE));
                int startDay = cursor.getInt(cursor.getColumnIndex(CalendarContract.Instances.START_DAY));
                long status = cursor.getLong(cursor.getColumnIndex(CalendarContract.Instances.SELF_ATTENDEE_STATUS));
                long startTime = cursor.getLong(cursor.getColumnIndex(CalendarContract.Events.DTSTART));
                long eventId = cursor.getLong(cursor.getColumnIndex(CalendarContract.Instances.EVENT_ID));
                return new EventCalendarItem(eventId, title, status, startDay, startTime);
            }
        };
    }

    static Func1<List<CalendarItem>, ItemSource<CalendarItem>> convertToSource(final DateTime now, final int size) {
        return new Func1<List<CalendarItem>, ItemSource<CalendarItem>>() {
            @Override
            public ItemSource<CalendarItem> call(List<CalendarItem> calendarItems) {
                SparseArrayCompat<CalendarItem> itemArray = new SparseArrayCompat<>();
                int lowestStartDay = getLowestStartDay(calendarItems);
                for (CalendarItem item : calendarItems) {
                    itemArray.put(item.startDay() - lowestStartDay, item);
                }
                return new CalendarSource(itemArray, size, now);
            }
        };
    }

    private static int getLowestStartDay(List<CalendarItem> calendarItems) {
        int lowest = Integer.MAX_VALUE;
        for (CalendarItem item : calendarItems) {
            if (lowest > item.startDay()) {
                lowest = item.startDay();
            }
        }
        return lowest;
    }
}
