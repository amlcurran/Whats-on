package uk.co.amlcurran.social

import androidx.recyclerview.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import org.joda.time.format.DateTimeFormat

import rx.Observer

internal class WhatsOnAdapter(
        private val layoutInflater: LayoutInflater,
        private val eventSelectedListener: EventSelectedListener,
        private var source: CalendarSource
) : RecyclerView.Adapter<CalendarItemViewHolder<*>>(), Observer<CalendarSource> {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CalendarItemViewHolder<*> {
        return when (viewType) {
            TYPE_EVENT -> EventViewHolder(layoutInflater.inflate(R.layout.item_event, parent, false), eventSelectedListener)
            TYPE_EMPTY -> EmptyViewHolder(layoutInflater.inflate(R.layout.item_empty, parent, false), eventSelectedListener)
            TYPE_DAY -> DayViewHolder(layoutInflater.inflate(R.layout.item_day, parent, false))
            else -> TODO("Not implemented")
        }
    }

    override fun onBindViewHolder(holder: CalendarItemViewHolder<*>, position: Int) {
        when (getItemViewType(position)) {
            TYPE_EVENT -> {
                val eventCalendarItem = source.itemAt(itemPositionFromAdapterPosition(position)) as EventCalendarItem
                (holder as EventViewHolder).bind(eventCalendarItem)
            }
            TYPE_EMPTY -> {
                val item = source.itemAt(itemPositionFromAdapterPosition(position)) as EmptyCalendarItem
                (holder as EmptyViewHolder).bind(item)
            }
            TYPE_DAY -> {
                val eventCalendarItem = source.itemAt(itemPositionFromAdapterPosition(position + 1))
                (holder as DayViewHolder).bind(eventCalendarItem!!)
            }
        }
    }

    private fun itemPositionFromAdapterPosition(position: Int) = (position - 1) / 2

    override fun getItemCount(): Int {
        return source.count() * 2
    }

    override fun onCompleted() {

    }

    override fun getItemViewType(position: Int): Int {
        if (position % 2 == 0) {
            return TYPE_DAY
        }
        return if (source.itemAt(itemPositionFromAdapterPosition(position))!!.isEmpty) TYPE_EMPTY else TYPE_EVENT
    }

    override fun onError(e: Throwable) {
        e.printStackTrace()
    }

    override fun onNext(source: CalendarSource) {
        this.source = source
        notifyDataSetChanged()
    }

    interface EventSelectedListener {
        fun eventSelected(calendarItem: EventCalendarItem, itemView: View)

        fun emptySelected(calendarItem: EmptyCalendarItem)
    }

    companion object {
        private const val TYPE_EVENT = 0
        private const val TYPE_EMPTY = 1
        private const val TYPE_DAY = 2
    }

}

class DayViewHolder(itemView: View?) : CalendarItemViewHolder<CalendarItem>(itemView) {

    private val dateFormatter = DateTimeFormat.fullDate()

    override fun bind(item: CalendarItem) {
        (itemView as TextView).text = dateFormatter.print(item.startTime.millis)
    }

}
