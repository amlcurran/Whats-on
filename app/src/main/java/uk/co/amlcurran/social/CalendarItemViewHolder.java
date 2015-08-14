package uk.co.amlcurran.social;

import android.support.v7.widget.RecyclerView;
import android.view.View;

public abstract class CalendarItemViewHolder<T extends CalendarItem> extends RecyclerView.ViewHolder {

    public CalendarItemViewHolder(View itemView) {
        super(itemView);
    }

    public abstract void bind(T item);

}
