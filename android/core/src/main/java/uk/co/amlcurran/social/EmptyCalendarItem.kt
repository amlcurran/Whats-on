package uk.co.amlcurran.social

class EmptyCalendarItem(private val startTime: Timestamp, private val endTime: Timestamp) : CalendarItem {

    override fun title(): String {
        return "Empty"
    }

    override fun startTime(): Timestamp {
        return startTime
    }

    override fun endTime(): Timestamp {
        return endTime
    }

    override var isEmpty: Boolean = true
}
