package uk.co.amlcurran.social

interface EventsRepository {

    fun getCalendarItems(nowTime: Timestamp, nextWeek: Timestamp, fivePm: TimeOfDay, elevenPm: TimeOfDay): List<Foo>

    fun event(eventId: String): Event?

    fun delete(eventId: String): Boolean
}
