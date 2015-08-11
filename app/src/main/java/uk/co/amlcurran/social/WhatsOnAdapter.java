package uk.co.amlcurran.social;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import rx.Observer;
import uk.co.amlcurran.social.bootstrap.BasicViewHolder;
import uk.co.amlcurran.social.bootstrap.ItemSource;

public class WhatsOnAdapter extends RecyclerView.Adapter<BasicViewHolder<CalendarItem>> implements Observer<ItemSource<CalendarItem>> {
    private final LayoutInflater layoutInflater;
    private final BasicViewHolder.Binder<CalendarItem> binder;
    private ItemSource<CalendarItem> source;

    public WhatsOnAdapter(LayoutInflater layoutInflater, ItemSource<CalendarItem> firstSource) {
        this.layoutInflater = layoutInflater;
        this.binder = new BasicViewHolder.Binder<CalendarItem>() {
            @Override
            public String bindItem(CalendarItem item) {
                return item.title();
            }
        };
        this.source = firstSource;
    }

    @Override
    public BasicViewHolder<CalendarItem> onCreateViewHolder(ViewGroup parent, int viewType) {
        return BasicViewHolder.from(layoutInflater, parent, binder);
    }

    @Override
    public void onBindViewHolder(BasicViewHolder<CalendarItem> holder, int position) {
        holder.bind(source.itemAt(position));
    }

    @Override
    public int getItemCount() {
        return source.count();
    }

    @Override
    public void onCompleted() {

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
}

