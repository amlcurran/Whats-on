package uk.co.amlcurran.social

import java.util.*

class CalendarSource(private val calendarItems: HashMap<Int, CalendarSlot>, private val daysSize: Int, private val timeCalculator: TimeCalculator, private val timeRepository: TimeRepository) {

    fun count(): Int {
        return daysSize
    }

    fun itemAt(position: Int): CalendarItem? {
        val calendarSlot = calendarItems.get(position)
        if (calendarSlot == null || calendarSlot.isEmpty) {
            val startTime = startOfTodayBlock(position)
            val endTime = endOfTodayBlock(position)
            return EmptyCalendarItem(startTime, endTime)
        }
        return calendarSlot.firstItem()
    }

    private fun startOfTodayBlock(position: Int): Timestamp {
        return timeCalculator.startOfToday().plusDays(position).plusHoursOf(timeRepository.borderTimeStart())
    }

    private fun endOfTodayBlock(position: Int): Timestamp {
        return timeCalculator.startOfToday().plusDays(position).plusHoursOf(timeRepository.borderTimeEnd())
    }

    fun slotAt(position: Int): CalendarSlot {
        return calendarItems[position] ?: CalendarSlot()
    }

    fun isEmptySlot(position: Int): Boolean {
        return slotAt(position).isEmpty
    }
}
