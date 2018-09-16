package uk.co.amlcurran.social;

import android.view.View;
import android.widget.TextView;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class EventViewHolder extends CalendarItemViewHolder<EventCalendarItem> {

    public static final DateTimeFormatter DAY_FORMATTER = DateTimeFormat.forPattern("EEE");
    private final TextView textView;
    private final WhatsOnAdapter.EventSelectedListener eventSelectedListener;

    public EventViewHolder(View itemView, WhatsOnAdapter.EventSelectedListener eventSelectedListener) {
        super(itemView);
        this.eventSelectedListener = eventSelectedListener;
        this.textView = ((TextView) itemView.findViewById(R.id.textView));
    }

    @Override
    public void bind(final EventCalendarItem item) {
        textView.setText(DAY_FORMATTER.print(item.startTime().getMillis()) + ": " + item.title());
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                eventSelectedListener.eventSelected(item);
            }
        });
    }

}
