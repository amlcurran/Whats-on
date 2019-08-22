package uk.co.amlcurran.social

import android.view.View
import android.widget.TextView

internal class EmptyViewHolder(itemView: View, private val eventSelectedListener: WhatsOnAdapter.EventSelectedListener) : CalendarItemViewHolder<EmptyCalendarItem>(itemView) {

    private val textView: TextView = itemView.findViewById(R.id.event_title)

    override fun bind(item: EmptyCalendarItem) {
        textView.setText(R.string.nothing_on)
        itemView.setOnClickListener { eventSelectedListener.emptySelected(item) }
    }
}
