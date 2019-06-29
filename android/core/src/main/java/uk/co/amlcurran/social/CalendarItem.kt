package uk.co.amlcurran.social

interface CalendarItem {

    val isEmpty: Boolean

    fun title(): String

    fun startTime(): Timestamp

    fun endTime(): Timestamp
}
