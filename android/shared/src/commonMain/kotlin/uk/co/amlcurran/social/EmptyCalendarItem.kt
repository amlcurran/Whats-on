package uk.co.amlcurran.social

import kotlinx.datetime.Instant

class EmptyCalendarItem(
    override val startTime: Instant,
    override val endTime: Instant
) :
    CalendarItem {

    override val title: String
        get() {
            return "Empty"
        }

    override var isEmpty: Boolean = true
}
