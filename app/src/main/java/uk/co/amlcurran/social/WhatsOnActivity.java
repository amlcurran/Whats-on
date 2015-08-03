package uk.co.amlcurran.social;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;

import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;
import uk.co.amlcurran.social.bootstrap.BasicViewHolder;
import uk.co.amlcurran.social.bootstrap.ItemSource;
import uk.co.amlcurran.social.bootstrap.RxAdapter;

public class WhatsOnActivity extends AppCompatActivity {

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
        });
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);

        Observable.create(new Observable.OnSubscribe<CalendarSource>() {
            @Override
            public void call(Subscriber<? super CalendarSource> subscriber) {
                subscriber.onNext(new CalendarSource());
            }
        }).subscribeOn(AndroidSchedulers.mainThread())
                .observeOn(Schedulers.io())
                .subscribe(adapter);
    }

    private class CalendarSource implements ItemSource<CalendarItem> {

        @Override
        public int count() {
            return 1;
        }

        @Override
        public CalendarItem itemAt(int position) {
            return new CalendarItem();
        }
    }

    private class CalendarItem {
        @Override
        public String toString() {
            return "TOOT TOOT";
        }
    }

}
