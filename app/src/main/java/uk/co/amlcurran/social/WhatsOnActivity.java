package uk.co.amlcurran.social;

import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.CalendarContract;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;

import org.joda.time.DateTime;

import java.util.Collections;
import java.util.List;

import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Func1;
import rx.schedulers.Schedulers;
import uk.co.amlcurran.social.bootstrap.BasicViewHolder;
import uk.co.amlcurran.social.bootstrap.ItemSource;
import uk.co.amlcurran.social.bootstrap.RxAdapter;

public class WhatsOnActivity extends AppCompatActivity {

    private static String[] PROJECTION = new String[]{
            CalendarContract.Events._ID,
            CalendarContract.Events.TITLE,
            CalendarContract.Instances.START_MINUTE,
            CalendarContract.Instances.END_MINUTE,
            CalendarContract.Instances.STATUS
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_whats_on);

        RecyclerView recyclerView = (RecyclerView) findViewById(R.id.list_whats_on);
        RxAdapter<CalendarSource, CalendarItem> adapter = new RxAdapter<>(LayoutInflater.from(this), new BasicViewHolder.Binder<CalendarItem>() {
            @Override
            public String bindItem(CalendarItem item) {
                return item.toString();
            }
        }, new CalendarSource(Collections.<CalendarItem>emptyList()));
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);

        Observable.create(new Observable.OnSubscribe<Cursor>() {
            @Override
            public void call(Subscriber<? super Cursor> subscriber) {
                long now = new DateTime().getMillis();
                long nextWeek = new DateTime().plusDays(14).getMillis();

                Uri.Builder builder = CalendarContract.Instances.CONTENT_URI.buildUpon();
                ContentUris.appendId(builder, now);
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
                .map(convertToSource())
                .subscribeOn(AndroidSchedulers.mainThread())
                .observeOn(Schedulers.io())
                .subscribe(adapter);
    }

    private static Func1<List<CalendarItem>, CalendarSource> convertToSource() {
        return new Func1<List<CalendarItem>, CalendarSource>() {
            @Override
            public CalendarSource call(List<CalendarItem> calendarItems) {
                return new CalendarSource(calendarItems);
            }
        };
    }

    private static Func1<Cursor, CalendarItem> convertToItem() {
        return new Func1<Cursor, CalendarItem>() {
            @Override
            public CalendarItem call(Cursor cursor) {
                String title = cursor.getString(cursor.getColumnIndex(CalendarContract.Events.TITLE));
                long status = cursor.getLong(cursor.getColumnIndex(CalendarContract.Instances.STATUS));
                return new EventCalendarItem(title, status);
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

    private static class CalendarSource implements ItemSource<CalendarItem> {

        private final List<CalendarItem> calendarItems;

        public CalendarSource(List<CalendarItem> calendarItems) {
            this.calendarItems = calendarItems;
        }

        @Override
        public int count() {
            return calendarItems.size();
        }

        @Override
        public CalendarItem itemAt(int position) {
            return calendarItems.get(position);
        }
    }

    private static class EventCalendarItem implements CalendarItem {
        private final String title;
        private final long status;

        public EventCalendarItem(String title, long status) {
            this.title = title;
            this.status = status;
        }

        @Override
        public String toString() {
            return title + " " + status;
        }
    }

}
