package uk.co.amlcurran.social;

import android.view.View;
import android.widget.TextView;

public class EmptyViewHolder extends CalendarItemViewHolder<EmptyCalendarItem> {

    private final TextView textView;

    public EmptyViewHolder(View itemView) {
        super(itemView);
        textView = ((TextView) itemView.findViewById(R.id.textView));
    }

    @Override
    public void bind(EmptyCalendarItem item) {
        textView.setText("AIM EMPTY INNIT");
    }
}
