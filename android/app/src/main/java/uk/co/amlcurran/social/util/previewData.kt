package uk.co.amlcurran.social.util

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import uk.co.amlcurran.social.CalendarSlot
import uk.co.amlcurran.social.EventCalendarItem
import java.util.UUID
import kotlin.time.DurationUnit
import kotlin.time.toDuration

val previewSlots = (0 until 10).map {
    val startTimestamp = Clock.System.now().plus(it.toDuration(DurationUnit.DAYS))
    CalendarSlot(
        makeEvents(it, startTimestamp),
        startTimestamp,
        startTimestamp.plus(6.toDuration(DurationUnit.HOURS))
    )
}

private fun makeEvents(
    position: Int,
    startTimestamp: Instant
): MutableList<EventCalendarItem> {
    val hasEvent = position % 3 == 0
    val hasTwoEvents = position % 7 == 0
    return when {
        hasTwoEvents -> mutableListOf(
            EventCalendarItem(
                UUID.randomUUID().toString(),
                "abc",
                "Event ${position + 1}",
                startTimestamp.plus(30.toDuration(DurationUnit.MINUTES)),
                startTimestamp.plus(90.toDuration(DurationUnit.MINUTES)),
                listOf()
            ),
            EventCalendarItem(
                UUID.randomUUID().toString(),
                "abc",
                "Other Event ${position + 1}",
                startTimestamp.plus(45.toDuration(DurationUnit.MINUTES)),
                startTimestamp.plus(90.toDuration(DurationUnit.MINUTES)),
                listOf()
            )
        )
        hasEvent -> mutableListOf(
            EventCalendarItem(
                UUID.randomUUID().toString(),
                "abc",
                "Event ${position + 1}",
                startTimestamp.plus(30.toDuration(DurationUnit.MINUTES)),
                startTimestamp.plus(90.toDuration(DurationUnit.MINUTES)),
                listOf()
            )
        )
        else -> mutableListOf()
    }
}