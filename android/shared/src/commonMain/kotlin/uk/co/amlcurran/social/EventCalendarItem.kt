package uk.co.amlcurran.social

class EventCalendarItem(
    val eventId: String,
    val calendarId: String,
    override val title: String,
    override val startTime: Timestamp,
    override val endTime: Timestamp,
    val attendees: List<Attendee>
) : CalendarItem {

    override var isEmpty: Boolean = false
}
