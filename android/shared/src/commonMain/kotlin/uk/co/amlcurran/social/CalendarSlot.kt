package uk.co.amlcurran.social

data class CalendarSlot(
    val items: MutableList<CalendarItem>,
    val startTimestamp: Timestamp,
    val endTimestamp: Timestamp
) {

    val isEmpty = items.isEmpty()

    val firstItem = items.firstOrNull() ?: EmptyCalendarItem(startTimestamp, endTimestamp)

    fun addItem(calendarItem: CalendarItem) {
        items.add(calendarItem)
    }

}
