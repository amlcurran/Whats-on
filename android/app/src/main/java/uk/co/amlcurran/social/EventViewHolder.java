package uk.co.amlcurran.social;

import android.view.View;
import android.widget.TextView;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class EventViewHolder extends CalendarItemViewHolder<EventCalendarItem> {

    private static final DateTimeFormatter FORMATTER = DateTimeFormat.shortTime();

    private final TextView textView;
    private final TextView timeTextView;
    private final WhatsOnAdapter.EventSelectedListener eventSelectedListener;
    private final JodaCalculator calculator = new JodaCalculator();

    public EventViewHolder(View itemView, WhatsOnAdapter.EventSelectedListener eventSelectedListener) {
        super(itemView);
        this.eventSelectedListener = eventSelectedListener;
        this.textView = itemView.findViewById(R.id.textView);
        this.timeTextView = itemView.findViewById(R.id.time_text_view);
    }

    @Override
    public void bind(final EventCalendarItem item) {
        textView.setText(item.title());
        String startTime = FORMATTER.print(calculator.getDateTime(item.startTime()));
        timeTextView.setText(timeTextView.getResources().getString(R.string.from_time, startTime));
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                eventSelectedListener.eventSelected(item);
            }
        });
    }

}
