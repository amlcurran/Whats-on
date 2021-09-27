package uk.co.amlcurran.social

class EmptyCalendarItem(override val startTime: Timestamp, override val endTime: Timestamp) :
    CalendarItem {

    override val title: String
        get() {
            return "Empty"
        }

    override var isEmpty: Boolean = true
}
