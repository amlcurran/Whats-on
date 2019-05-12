package uk.co.amlcurran.social

import androidx.recyclerview.widget.RecyclerView
import android.view.LayoutInflater
import android.view.ViewGroup

import rx.Observer

internal class WhatsOnAdapter(
        private val layoutInflater: LayoutInflater,
        private val eventSelectedListener: EventSelectedListener,
        private var source: CalendarSource
) : RecyclerView.Adapter<CalendarItemViewHolder<*>>(), Observer<CalendarSource> {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CalendarItemViewHolder<*> {
        return if (viewType == TYPE_EVENT) {
            EventViewHolder(layoutInflater.inflate(R.layout.item_event, parent, false), eventSelectedListener)
        } else {
            EmptyViewHolder(layoutInflater.inflate(R.layout.item_empty, parent, false), eventSelectedListener)
        }
    }

    override fun onBindViewHolder(holder: CalendarItemViewHolder<*>, position: Int) {
        if (getItemViewType(position) != TYPE_EMPTY) {
            val eventCalendarItem = source.itemAt(position) as EventCalendarItem
            (holder as EventViewHolder).bind(eventCalendarItem)
        } else {
            val item = source.itemAt(position) as EmptyCalendarItem
            (holder as EmptyViewHolder).bind(item)
        }
    }

    override fun getItemCount(): Int {
        return source.count()
    }

    override fun onCompleted() {

    }

    override fun getItemViewType(position: Int): Int {
        return if (source.itemAt(position)!!.isEmpty) TYPE_EMPTY else TYPE_EVENT
    }

    override fun onError(e: Throwable) {
        e.printStackTrace()
    }

    override fun onNext(source: CalendarSource) {
        this.source = source
        notifyDataSetChanged()
    }

    interface EventSelectedListener {
        fun eventSelected(calendarItem: EventCalendarItem)

        fun emptySelected(calendarItem: EmptyCalendarItem)
    }

    companion object {
        private const val TYPE_EVENT = 0
        private const val TYPE_EMPTY = 1
    }

}

