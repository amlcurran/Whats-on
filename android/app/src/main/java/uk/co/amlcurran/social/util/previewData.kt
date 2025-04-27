package uk.co.amlcurran.social.util

import kotlinx.datetime.Clock
import uk.co.amlcurran.social.CalendarSlot
import uk.co.amlcurran.social.EventCalendarItem
import java.util.UUID
import kotlin.time.DurationUnit
import kotlin.time.toDuration

val previewSlots = (0 until 10).map {
    val hasEvent = it % 3 == 0
    val startTimestamp = Clock.System.now().plus(it.toDuration(DurationUnit.DAYS))
    CalendarSlot(
        if (hasEvent) mutableListOf(EventCalendarItem(
            UUID.randomUUID().toString(),
            "abc",
            "Event ${it + 1}",
            startTimestamp.plus(30.toDuration(DurationUnit.MINUTES)),
            startTimestamp.plus(90.toDuration(DurationUnit.MINUTES)),
            listOf()
        )) else mutableListOf(),
        startTimestamp,
        startTimestamp.plus(6.toDuration(DurationUnit.HOURS))
    )
}