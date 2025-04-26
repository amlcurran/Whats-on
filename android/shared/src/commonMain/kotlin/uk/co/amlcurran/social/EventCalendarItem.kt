package uk.co.amlcurran.social

import kotlinx.datetime.Instant

data class EventCalendarItem(
    val eventId: String,
    val calendarId: String,
    override val title: String,
    override val startTime: Instant,
    override val endTime: Instant,
    val attendees: List<Attendee>
) : CalendarItem {

    override var isEmpty: Boolean = false
}
