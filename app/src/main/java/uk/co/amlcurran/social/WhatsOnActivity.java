package uk.co.amlcurran.social;

import android.database.Cursor;
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
                long time = new DateTime().minusDays(7).getMillis();
                Cursor calendarCursor = CalendarContract.Instances.query(getContentResolver(), PROJECTION, time, now);
                System.out.println("Calendar size " + calendarCursor.getCount());
                while (calendarCursor.moveToNext()){
                    subscriber.onNext(calendarCursor);
                }
                subscriber.onCompleted();
                calendarCursor.close();
            }
        })
                .filter(new Func1<Cursor, Boolean>() {
                    @Override
                    public Boolean call(Cursor cursor) {
                        long fivePm = 17 * 60;
                        long tenPm = 23 * 60;
                        boolean isPastFive = cursor.getLong(cursor.getColumnIndex(CalendarContract.Instances.START_MINUTE)) >= fivePm;
                        boolean isBeforeEleven = cursor.getLong(cursor.getColumnIndex(CalendarContract.Instances.END_MINUTE)) <= tenPm;
                        return isPastFive && isBeforeEleven;
                    }
                })
                .map(new Func1<Cursor, CalendarItem>() {
                    @Override
                    public CalendarItem call(Cursor cursor) {
                        String title = cursor.getString(cursor.getColumnIndex(CalendarContract.Events.TITLE));
                        return new CalendarItem(title);
                    }
                })
                .toList()
                .map(new Func1<List<CalendarItem>, CalendarSource>() {
                    @Override
                    public CalendarSource call(List<CalendarItem> calendarItems) {
                        return new CalendarSource(calendarItems);
                    }
                })
                .subscribeOn(AndroidSchedulers.mainThread())
                .observeOn(Schedulers.io())
                .subscribe(adapter);
    }

    private class CalendarSource implements ItemSource<CalendarItem> {

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

    private class CalendarItem {
        private final String title;

        public CalendarItem(String title) {
            this.title = title;
        }

        @Override
        public String toString() {
            return title;
        }
    }

}
