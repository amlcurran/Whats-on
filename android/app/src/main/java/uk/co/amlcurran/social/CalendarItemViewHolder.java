package uk.co.amlcurran.social;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

public abstract class CalendarItemViewHolder<T extends CalendarItem> extends RecyclerView.ViewHolder {

    public CalendarItemViewHolder(View itemView) {
        super(itemView);
    }

    public abstract void bind(T item);

}
