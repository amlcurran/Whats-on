package uk.co.amlcurran.social;

import android.view.View;
import android.widget.TextView;

public class EventViewHolder extends CalendarItemViewHolder<EventCalendarItem> {

    public EventViewHolder(View itemView) {
        super(itemView);
    }

    @Override
    public void bind(EventCalendarItem item) {
        ((TextView) itemView).setText(item.title());
    }

}
