package uk.co.amlcurran.social

import kotlinx.collections.immutable.ImmutableList
import kotlinx.datetime.Instant

interface EventsRepository {

    fun getCalendarItems(
        nowTime: Instant,
        nextWeek: Instant,
        fivePm: TimeOfDay,
        elevenPm: TimeOfDay
    ): List<Foo>

    fun event(eventId: String): Event?

    fun delete(eventId: String): Boolean
    fun attendeesForEvent(event: Foo): ImmutableList<Attendee>
}

data class Attendee(
    val id: String,
    val name: String,
    val email: String
)