package uk.co.amlcurran.social;

import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.CalendarContract;
import android.support.annotation.Nullable;
import android.support.v4.util.SparseArrayCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;

import org.joda.time.DateTime;

import java.util.List;

import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

public class WhatsOnActivity extends AppCompatActivity {

    private static String[] PROJECTION = new String[]{
            CalendarContract.Events._ID,
            CalendarContract.Events.TITLE,
            CalendarContract.Instances.START_MINUTE,
            CalendarContract.Instances.START_DAY,
            CalendarContract.Instances.END_MINUTE,
            CalendarContract.Instances.STATUS
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_whats_on);

        RecyclerView recyclerView = (RecyclerView) findViewById(R.id.list_whats_on);
        WhatsOnAdapter adapter = new WhatsOnAdapter(LayoutInflater.from(this), new CalendarSource(new SparseArrayCompat<CalendarItem>(0), 14));
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);

        Observable.create(new Observable.OnSubscribe<Cursor>() {
            @Override
            public void call(Subscriber<? super Cursor> subscriber) {
                DateTime now = new DateTime();
                long nowMillis = now.getMillis();
                long nextWeek = now.plusDays(14).getMillis();

                Uri.Builder builder = CalendarContract.Instances.CONTENT_URI.buildUpon();
                ContentUris.appendId(builder, nowMillis);
                ContentUris.appendId(builder, nextWeek);

                long fivePm = 17 * 60;
                long elevenPm = 23 * 60;

                String selection = String.format("%1$s >= %2$d AND %3$s <= %4$d",
                        CalendarContract.Instances.START_MINUTE, fivePm,
                        CalendarContract.Instances.END_MINUTE, elevenPm);

                Cursor calendarCursor = getContentResolver().query(builder.build(), PROJECTION, selection, null, null);
                while (calendarCursor.moveToNext()) {
                    subscriber.onNext(calendarCursor);
                }
                subscriber.onCompleted();
                calendarCursor.close();
            }
        })
                .filter(neverFilter())
                .map(convertToItem())
                .toList()
                .map(convertToSource(14))
                .subscribeOn(AndroidSchedulers.mainThread())
                .observeOn(Schedulers.io())
                .subscribe(adapter);
    }

    static Func1<List<CalendarItem>, CalendarSource> convertToSource(final int size) {
        return new Func1<List<CalendarItem>, CalendarSource>() {
            @Override
            public CalendarSource call(List<CalendarItem> calendarItems) {
                SparseArrayCompat<CalendarItem> itemArray = new SparseArrayCompat<>();
                int lowestStartDay = getLowestStartDay(calendarItems);
                for (CalendarItem item : calendarItems) {
                    itemArray.put(item.startDay() - lowestStartDay, item);
                }
                return new CalendarSource(itemArray, size);
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

    private static Func1<Cursor, CalendarItem> convertToItem() {
        return new Func1<Cursor, CalendarItem>() {
            @Override
            public CalendarItem call(Cursor cursor) {
                String title = cursor.getString(cursor.getColumnIndex(CalendarContract.Events.TITLE));
                long status = cursor.getLong(cursor.getColumnIndex(CalendarContract.Instances.STATUS));
                int startDay = cursor.getInt(cursor.getColumnIndex(CalendarContract.Instances.START_DAY));
                return new EventCalendarItem(title, status, startDay);
            }
        };
    }

    private static Func1<Cursor, Boolean> neverFilter() {
        return new Func1<Cursor, Boolean>() {
            @Override
            public Boolean call(Cursor cursor) {
                return true;
            }
        };
    }

}
