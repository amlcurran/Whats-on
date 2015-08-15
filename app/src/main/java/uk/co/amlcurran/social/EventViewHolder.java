package uk.co.amlcurran.social;

import android.view.View;
import android.widget.TextView;

public class EventViewHolder extends CalendarItemViewHolder<EventCalendarItem> {

    private final TextView textView;

    public EventViewHolder(View itemView) {
        super(itemView);
        textView = ((TextView) itemView.findViewById(R.id.textView));
    }

    @Override
    public void bind(EventCalendarItem item) {
        textView.setText(item.title());
    }

}
