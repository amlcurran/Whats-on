package uk.co.amlcurran.social.bootstrap;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import rx.Observer;

public class RxAdapter<Source extends ItemSource<Item>, Item> extends RecyclerView.Adapter<BasicViewHolder<Item>> implements Observer<Source> {
    private final LayoutInflater layoutInflater;
    private final BasicViewHolder.Binder<Item> binder;
    private Source source;

    public RxAdapter(LayoutInflater layoutInflater, BasicViewHolder.Binder<Item> binder) {
        this.layoutInflater = layoutInflater;
        this.binder = binder;
    }

    @Override
    public BasicViewHolder<Item> onCreateViewHolder(ViewGroup parent, int viewType) {
        return BasicViewHolder.from(layoutInflater, parent, binder);
    }

    @Override
    public void onBindViewHolder(BasicViewHolder<Item> holder, int position) {
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
    public void onNext(Source source) {
        this.source = source;
        notifyDataSetChanged();
    }
}

