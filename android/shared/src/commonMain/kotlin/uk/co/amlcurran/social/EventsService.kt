package uk.co.amlcurran.social

import android.provider.CalendarContract

data class Event(val item: EventCalendarItem, val location: String?)
data class Foo(val eventId: String, val calendarId: String, val title: String, val time: Timestamp, val endTime: Timestamp, val allDay: Boolean, val attendingStatus: Int, val isDeleted: Boolean, val startMinute: Int, val endMinute: Int)

class EventsService(
    private val timeRepository: TimeRepository,
    private val eventsRepository: EventsRepository,
    private val timeCalculator: TimeCalculator,
    private val userSettings: UserSettings
) {

    suspend fun getCalendarSource(numberOfDays: Int, now: Timestamp): CalendarSource {
        val nowTime = timeCalculator.startOfToday()
        val nextWeek = nowTime.plusDays(numberOfDays)
        val fivePm = timeRepository.borderTimeStart()
        val elevenPm = timeRepository.borderTimeEnd()

        val calendarItems = eventsRepository.getCalendarItems(nowTime, nextWeek, fivePm, elevenPm)
            .asSequence()
            .filter { it.allDay == false }
            .filter { it.attendingStatus != CalendarContract.Events.STATUS_CANCELED }
            .filter { it.isDeleted == false }
            .filter { (it.startMinute > elevenPm.minutesInDay() || it.endMinute < fivePm.minutesInDay()) == false }
            .filter { userSettings.shouldShowEvent(it.eventId) }
            .map { EventCalendarItem(it.eventId, it.calendarId, it.title, it.time, it.endTime) }
            .filter { userSettings.shouldShow(it) }
            .toList()

        val itemArray = mutableMapOf<Int, CalendarSlot>()
        val epochToNow = now.daysSinceEpoch()
        for (item in calendarItems) {
            val key = item.startTime.daysSinceEpoch() - epochToNow
            val slot = itemArray[key] ?: CalendarSlot()
            slot.addItem(item)
            itemArray[key] = slot
        }

        return CalendarSource(itemArray, numberOfDays, timeCalculator, timeRepository)
    }

    fun eventWithId(eventId: String): Event? = eventsRepository.event(eventId)

    fun delete(eventId: String): Boolean = eventsRepository.delete(eventId)

}
