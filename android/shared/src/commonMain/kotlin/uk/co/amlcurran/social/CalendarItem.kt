package uk.co.amlcurran.social

import kotlinx.datetime.Instant

interface CalendarItem {

    val isEmpty: Boolean

    val title: String

    val startTime: Instant

    val endTime: Instant
}
