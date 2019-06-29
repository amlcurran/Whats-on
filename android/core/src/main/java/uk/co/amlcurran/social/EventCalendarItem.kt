package uk.co.amlcurran.social

class EventCalendarItem(private val eventId: String, private val title: String, private val start: Timestamp, private val endTime: Timestamp) : CalendarItem {

    fun id(): String {
        return eventId
    }

    override fun title(): String {
        return title
    }

    override fun startTime(): Timestamp {
        return start
    }

    override fun endTime(): Timestamp {
        return endTime
    }

    override var isEmpty: Boolean = false
}
