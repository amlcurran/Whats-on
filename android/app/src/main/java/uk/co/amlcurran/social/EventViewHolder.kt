package uk.co.amlcurran.social

import android.view.View
import android.widget.TextView

import org.joda.time.format.DateTimeFormat

internal class EventViewHolder(itemView: View, private val eventSelectedListener: WhatsOnAdapter.EventSelectedListener) : CalendarItemViewHolder<EventCalendarItem>(itemView) {

    private val textView: TextView = itemView.findViewById(R.id.textView)
    private val subtitle: TextView = itemView.findViewById(R.id.event_subtitle)
    private val formatter = DateTimeFormat.shortTime()
    private val jodaCalculator = JodaCalculator()

    override fun bind(item: EventCalendarItem) {
        textView.text = item.title
        val time = jodaCalculator.getDateTime(item.startTime)
        subtitle.text = itemView.resources.getString(R.string.event_from, formatter.print(time))
        itemView.setOnClickListener { eventSelectedListener.eventSelected(item, itemView) }
    }

}
