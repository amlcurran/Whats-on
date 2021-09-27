package uk.co.amlcurran.social

class EventCalendarItem(
    private val eventId: String,
    val calendarId: String,
    override val title: String,
    override val startTime: Timestamp,
    override val endTime: Timestamp
) : CalendarItem {

    fun id(): String {
        return eventId
    }

    override var isEmpty: Boolean = false
}
