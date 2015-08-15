package uk.co.amlcurran.social;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import rx.Observer;
import uk.co.amlcurran.social.bootstrap.ItemSource;

public class WhatsOnAdapter extends RecyclerView.Adapter<CalendarItemViewHolder> implements Observer<ItemSource<CalendarItem>> {
    private static final int TYPE_EVENT = 0;
    private static final int TYPE_EMPTY = 1;
    private final LayoutInflater layoutInflater;
    private final EventSelectedListener eventSelectedListener;
    private ItemSource<CalendarItem> source;

    public WhatsOnAdapter(LayoutInflater layoutInflater, EventSelectedListener eventSelectedListener, ItemSource<CalendarItem> firstSource) {
        this.layoutInflater = layoutInflater;
        this.eventSelectedListener = eventSelectedListener;
        this.source = firstSource;
    }

    @Override
    public CalendarItemViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == TYPE_EVENT) {
            return new EventViewHolder(layoutInflater.inflate(R.layout.item_event, parent, false), eventSelectedListener);
        } else {
            return new EmptyViewHolder(layoutInflater.inflate(R.layout.item_empty, parent, false), eventSelectedListener);
        }
    }

    @Override
    public void onBindViewHolder(CalendarItemViewHolder holder, int position) {
        if (getItemViewType(position) != TYPE_EMPTY) {
            EventCalendarItem eventCalendarItem = (EventCalendarItem) source.itemAt(position);
            ((EventViewHolder) holder).bind(eventCalendarItem);
        } else {
            EmptyCalendarItem item = ((EmptyCalendarItem) source.itemAt(position));
            ((EmptyViewHolder) holder).bind(item);
        }
    }

    @Override
    public int getItemCount() {
        return source.count();
    }

    @Override
    public void onCompleted() {

    }

    @Override
    public int getItemViewType(int position) {
        return source.itemAt(position).isEmpty() ? TYPE_EMPTY : TYPE_EVENT;
    }

    @Override
    public void onError(Throwable e) {
        e.printStackTrace();
    }

    @Override
    public void onNext(ItemSource<CalendarItem> source) {
        this.source = source;
        notifyDataSetChanged();
    }

    public interface EventSelectedListener {
        void eventSelected(EventCalendarItem calendarItem);

        void emptySelected(EmptyCalendarItem calendarItem);
    }

}

