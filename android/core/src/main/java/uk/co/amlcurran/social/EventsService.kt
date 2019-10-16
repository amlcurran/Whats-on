package uk.co.amlcurran.social

data class Event(val item: EventCalendarItem, val location: String)

class EventsService(
        private val timeRepository: TimeRepository,
        private val eventsRepository: EventsRepository,
        private val timeCalculator: TimeCalculator
) {

    fun getCalendarSource(numberOfDays: Int, now: Timestamp): CalendarSource {
        val nowTime = timeCalculator.startOfToday()
        val nextWeek = nowTime.plusDays(numberOfDays)
        val fivePm = timeRepository.borderTimeStart()
        val elevenPm = timeRepository.borderTimeEnd()

        val calendarItems = eventsRepository.getCalendarItems(nowTime, nextWeek, fivePm, elevenPm)

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

}
