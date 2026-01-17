package uk.co.amlcurran.social

import kotlinx.collections.immutable.ImmutableList
import kotlinx.collections.immutable.toImmutableList
import kotlinx.datetime.Instant

data class CalendarSlot(
    val items: ImmutableList<EventCalendarItem>,
    val startTimestamp: Instant,
    val endTimestamp: Instant
) {

    val isEmpty: Boolean
        get() = items.isEmpty()

    val firstItem: CalendarItem
        get() = items.firstOrNull() ?: EmptyCalendarItem(startTimestamp, endTimestamp)

    fun appending(calendarItem: EventCalendarItem): CalendarSlot {
        return copy(
            items = (items + calendarItem).toImmutableList()
        )
    }

}
