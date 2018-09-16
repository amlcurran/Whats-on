package uk.co.amlcurran.social.bootstrap;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class BasicViewHolder<T> extends RecyclerView.ViewHolder {
    private final Binder<T> binder;

    public BasicViewHolder(View itemView, Binder<T> binder) {
        super(itemView);
        this.binder = binder;
    }

    public static <T> BasicViewHolder<T> from(LayoutInflater layoutInflater, ViewGroup parent, Binder<T> binder) {
        View item = layoutInflater.inflate(android.R.layout.simple_list_item_1, parent, false);
        return new BasicViewHolder<>(item, binder);
    }

    public void bind(T item) {
        ((TextView) itemView).setText(binder.bindItem(item));
    }

    public interface Binder<T> {
        String bindItem(T item);
    }

}
