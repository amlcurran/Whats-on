package uk.co.amlcurran.social

data class CalendarSlot(
    val items: MutableList<EventCalendarItem>,
    val startTimestamp: Timestamp,
    val endTimestamp: Timestamp
) {

    val isEmpty: Boolean
        get() = items.isEmpty()

    val firstItem: CalendarItem
        get() = items.firstOrNull() ?: EmptyCalendarItem(startTimestamp, endTimestamp)

    fun addItem(calendarItem: EventCalendarItem) {
        items.add(calendarItem)
    }

}
