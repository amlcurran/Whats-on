package uk.co.amlcurran.social

import java.util.ArrayList

class CalendarSlot {
    private val calendarItems = ArrayList<CalendarItem>()

    val isEmpty: Boolean
        get() = calendarItems.isEmpty()

    fun firstItem(): CalendarItem? {
        return calendarItems[0]
    }

    fun addItem(item: CalendarItem) {
        this.calendarItems.add(item)
    }

    fun count(): Int {
        return calendarItems.size
    }

    fun items(): List<CalendarItem> {
        return calendarItems
    }
}
