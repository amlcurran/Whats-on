package uk.co.amlcurran.social;

import android.view.View;
import android.widget.TextView;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class EventViewHolder extends CalendarItemViewHolder<EventCalendarItem> {

    private final TextView textView;
    private final WhatsOnAdapter.EventSelectedListener eventSelectedListener;
    private final TextView subtitle;
    private final DateTimeFormatter formatter = DateTimeFormat.shortTime();
    private final JodaCalculator jodaCalculator = new JodaCalculator();

    public EventViewHolder(View itemView, WhatsOnAdapter.EventSelectedListener eventSelectedListener) {
        super(itemView);
        this.eventSelectedListener = eventSelectedListener;
        this.textView = itemView.findViewById(R.id.textView);
        this.subtitle = itemView.findViewById(R.id.event_subtitle);
    }

    @Override
    public void bind(final EventCalendarItem item) {
        textView.setText(item.getTitle());
        subtitle.setText(subtitle.getResources().getString(R.string.event_from, formatter.print(jodaCalculator.getDateTime(item.getStartTime()))));
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                eventSelectedListener.eventSelected(item, itemView);
            }
        });
    }

}
