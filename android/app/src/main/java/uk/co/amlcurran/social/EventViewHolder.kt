package uk.co.amlcurran.social

import android.view.View
import android.widget.TextView

import org.joda.time.format.DateTimeFormat
import uk.co.amlcurran.social.details.format

internal class EventViewHolder(itemView: View, private val eventSelectedListener: WhatsOnAdapter.EventSelectedListener) : CalendarItemViewHolder<EventCalendarItem>(itemView) {

    private val textView: TextView = itemView.findViewById(R.id.event_title)
    private val subtitle: TextView = itemView.findViewById(R.id.event_subtitle)
    private val formatter = DateTimeFormat.shortTime()
    private val jodaCalculator = JodaCalculator()

    override fun bind(item: EventCalendarItem) {
        textView.text = item.title
        subtitle.text = itemView.resources.getString(R.string.event_from, item.startTime.format(formatter, jodaCalculator))
        itemView.setOnClickListener { eventSelectedListener.eventSelected(item, itemView) }
    }

}
