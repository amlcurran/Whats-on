package uk.co.amlcurran.social

data class Event(val item: EventCalendarItem, val location: String?)
data class Foo(val eventId: String, val calendarId: String, val title: String, val time: Timestamp, val endTime: Timestamp, val allDay: Boolean, val attendingStatus: Int, val isDeleted: Boolean, val startMinute: Int, val endMinute: Int)

data class EventPredicate(
    val id: String,
    val predicate: (Foo) -> Boolean
)

class EventsService(
    private val eventsRepository: EventsRepository,
    private val timeCalculator: TimeCalculator,
    private val userSettings: UserSettings,
    private val predicate: EventPredicate
) {

    suspend fun getCalendarSource(numberOfDays: Int, now: Timestamp): CalendarSource {
        val nowTime = timeCalculator.startOfToday()
        val nextWeek = nowTime.plusDays(numberOfDays, timeCalculator)
        val fivePm = userSettings.borderTimeStart()
        val elevenPm = userSettings.borderTimeEnd()

        val calendarItems = eventsRepository.getCalendarItems(nowTime, nextWeek, fivePm, elevenPm)
            .asSequence()
            .filter { predicate.predicate(it) }
            .filterNot { it.startMinute > elevenPm.minutesInDay() || it.endMinute < fivePm.minutesInDay() }
            .map { it to eventsRepository.attendeesForEvent(it) }
            .map { (it, attendees) -> EventCalendarItem(it.eventId, it.calendarId, it.title, it.time, it.endTime, attendees) }
            .toList()

        val itemArray = mutableMapOf<Int, CalendarSlot>()
        val epochToNow = now.daysSinceEpoch(timeCalculator)
        for (item in calendarItems) {
            val key = item.startTime.daysSinceEpoch(timeCalculator) - epochToNow
            val slot = itemArray[key] ?: CalendarSlot(
                mutableListOf(),
                startOfTodayBlock(key),
                endOfTodayBlock(key)
            )
            slot.addItem(item)
            itemArray[key] = slot
        }

        return CalendarSource(itemArray, numberOfDays, timeCalculator, userSettings)
    }

    private fun startOfTodayBlock(position: Int): Timestamp {
        return timeCalculator.startOfToday()
            .plusDays(position, timeCalculator)
            .plusHoursOf(userSettings.borderTimeStart(), timeCalculator)
    }

    private fun endOfTodayBlock(position: Int): Timestamp {
        return timeCalculator.startOfToday()
            .plusDays(position, timeCalculator)
            .plusHoursOf(userSettings.borderTimeEnd(), timeCalculator)
    }

    fun eventWithId(eventId: String): Event? = eventsRepository.event(eventId)

    fun delete(eventId: String): Boolean = eventsRepository.delete(eventId)

}
