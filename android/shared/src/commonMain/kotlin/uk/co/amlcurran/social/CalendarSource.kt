package uk.co.amlcurran.social

class CalendarSource(private val calendarItems: Map<Int, CalendarSlot>, private val daysSize: Int, private val timeCalculator: TimeCalculator, private val userSettings: UserSettings) {

    fun count(): Int {
        return daysSize
    }

    fun itemAt(position: Int): CalendarItem {
        val calendarSlot = calendarItems[position]
        if (calendarSlot == null || calendarSlot.isEmpty) {
            val startTime = startOfTodayBlock(position)
            val endTime = endOfTodayBlock(position)
            return EmptyCalendarItem(startTime, endTime)
        }
        return calendarSlot.firstItem!!
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
