package uk.co.amlcurran.social;

import android.content.ContentUris;
import android.content.Intent;
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
import org.joda.time.DateTimeZone;

import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

public class WhatsOnActivity extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_whats_on);
        DateTime now = DateTime.now(DateTimeZone.getDefault());

        RecyclerView recyclerView = (RecyclerView) findViewById(R.id.list_whats_on);
        WhatsOnAdapter adapter = new WhatsOnAdapter(LayoutInflater.from(this), new WhatsOnAdapter.EventSelectedListener() {
            @Override
            public void eventSelected(EventCalendarItem calendarItem) {
                Uri eventUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, calendarItem.id());
                startActivity(new Intent(Intent.ACTION_VIEW).setData(eventUri));
            }

            @Override
            public void emptySelected(EmptyCalendarItem calendarItem) {
                Intent intent = new Intent(Intent.ACTION_INSERT);
                intent.setData(CalendarContract.Events.CONTENT_URI);
                DateTime dateTime = DateTime.now(DateTimeZone.getDefault()).withTimeAtStartOfDay();
                DateTime day = dateTime.plusDays(calendarItem.startDay());
                DateTime startTime = day.plusHours(17);
                DateTime endTime = day.plusHours(22);
                intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.getMillis());
                intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.getMillis());
                startActivity(intent);
            }

        }, new CalendarSource(new SparseArrayCompat<CalendarItem>(0), 0, now));
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);


        new EventsRepository(getContentResolver()).queryEventsFrom(now, 14)
                .subscribeOn(AndroidSchedulers.mainThread())
                .observeOn(Schedulers.io())
                .subscribe(adapter);
    }

}
