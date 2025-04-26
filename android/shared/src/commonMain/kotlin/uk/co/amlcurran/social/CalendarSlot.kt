package uk.co.amlcurran.social

import kotlinx.datetime.Instant

data class CalendarSlot(
    val items: MutableList<EventCalendarItem>,
    val startTimestamp: Instant,
    val endTimestamp: Instant
) {

    val isEmpty: Boolean
        get() = items.isEmpty()

    val firstItem: CalendarItem
        get() = items.firstOrNull() ?: EmptyCalendarItem(startTimestamp, endTimestamp)

    fun addItem(calendarItem: EventCalendarItem) {
        items.add(calendarItem)
    }

}
