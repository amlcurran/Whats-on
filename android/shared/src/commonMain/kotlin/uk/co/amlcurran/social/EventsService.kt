package uk.co.amlcurran.social

import kotlinx.collections.immutable.persistentListOf
import kotlinx.collections.immutable.toImmutableList
import kotlinx.datetime.Instant

data class Event(val item: EventCalendarItem, val location: String?)
data class Foo(
    val eventId: String,
    val calendarId: String,
    val title: String,
    val time: Instant,
    val endTime: Instant,
    val allDay: Boolean,
    val attendingStatus: Int,
    val isDeleted: Boolean,
    val startMinute: Int,
    val endMinute: Int
)

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

    suspend fun getCalendarSource(
        numberOfDays: Int,
        now: Instant
    ): CalendarSource {
        val nowTime = timeCalculator.startOfToday()
        val nextWeek = nowTime.plusDays(numberOfDays)
        val fivePm = userSettings.borderTimeStart()
        val elevenPm = userSettings.borderTimeEnd()

        val calendarItems = eventsRepository.getCalendarItems(nowTime, nextWeek, fivePm, elevenPm)
            .asSequence()
            .filter { predicate.predicate(it) }
            .filterNot { it.startMinute > elevenPm.minutesInDay() || it.endMinute < fivePm.minutesInDay() }
            .map { it to eventsRepository.attendeesForEvent(it) }
            .map { (it, attendees) ->
                EventCalendarItem(
                    it.eventId,
                    it.calendarId,
                    it.title,
                    it.time,
                    it.endTime,
                    attendees
                )
            }
            .toList()

        val itemArray = (0 until numberOfDays).map {
            CalendarSlot(persistentListOf(), startOfTodayBlock(it), endOfTodayBlock(it))
        }.toMutableList()
        val epochToNow = now.daysSinceEpoch(timeCalculator)
        for (item in calendarItems) {
            val key = item.startTime.daysSinceEpoch(timeCalculator) - epochToNow
            val slot = itemArray[key]
            itemArray[key] = slot.appending(item)
        }

        return CalendarSource(itemArray.toImmutableList())
    }

    private fun startOfTodayBlock(position: Int): Instant {
        return timeCalculator.startOfToday()
            .plusDays(position)
            .plusHoursOf(userSettings.borderTimeStart())
    }

    private fun endOfTodayBlock(position: Int): Instant {
        return timeCalculator.startOfToday()
            .plusDays(position)
            .plusHoursOf(userSettings.borderTimeEnd())
    }

    fun eventWithId(eventId: String): Event? = eventsRepository.event(eventId)

    fun delete(eventId: String): Boolean = eventsRepository.delete(eventId)

}
