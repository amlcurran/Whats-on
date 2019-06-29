package uk.co.amlcurran.social

interface CalendarItem {

    val isEmpty: Boolean

    val title: String

    val startTime: Timestamp

    val endTime: Timestamp
}
