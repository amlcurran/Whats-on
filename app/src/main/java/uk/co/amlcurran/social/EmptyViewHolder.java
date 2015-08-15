package uk.co.amlcurran.social;

import android.view.View;
import android.widget.TextView;

public class EmptyViewHolder extends CalendarItemViewHolder<EmptyCalendarItem> {

    private final TextView textView;
    private final WhatsOnAdapter.EventSelectedListener eventSelectedListener;

    public EmptyViewHolder(View itemView, WhatsOnAdapter.EventSelectedListener eventSelectedListener) {
        super(itemView);
        this.eventSelectedListener = eventSelectedListener;
        this.textView = ((TextView) itemView.findViewById(R.id.textView));
    }

    @Override
    public void bind(final EmptyCalendarItem item) {
        textView.setText("AIM EMPTY INNIT");
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                eventSelectedListener.emptySelected(item);
            }
        });
    }
}
