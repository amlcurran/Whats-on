package uk.co.amlcurran.social

import kotlinx.datetime.Instant

data class CalendarSource(private val calendarItems: Map<Int, CalendarSlot>, private val daysSize: Int, private val timeCalculator: TimeCalculator, private val userSettings: UserSettings) {

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

    fun slotAt(position: Int): CalendarSlot {
        return calendarItems[position] ?: CalendarSlot(
            mutableListOf(),
            startOfTodayBlock(position),
            endOfTodayBlock(position)
        )
    }

    fun allSlots(): List<CalendarSlot> {
        return (0 until daysSize).map {
            slotAt(it)
        }
    }

    fun isEmptySlot(position: Int): Boolean {
        return slotAt(position).isEmpty
    }
}
