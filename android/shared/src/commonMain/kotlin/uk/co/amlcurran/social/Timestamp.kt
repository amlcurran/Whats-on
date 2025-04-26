package uk.co.amlcurran.social

import kotlinx.datetime.DateTimeUnit
import kotlinx.datetime.Instant
import kotlinx.datetime.plus
import kotlin.time.DurationUnit
import kotlin.time.ExperimentalTime
import kotlin.time.toDuration

@OptIn(ExperimentalTime::class)
fun Instant.plusDays(days: Int): Instant {
    return plus(days.toDuration(DurationUnit.DAYS))
}

fun Instant.daysSinceEpoch(timeCalculator: TimeCalculator): Int {
    return timeCalculator.getDays(this)
}

fun Instant.plusHoursOf(timeOfDay: TimeOfDay): Instant {
    return plus(timeOfDay.hoursInDay().toInt(), DateTimeUnit.HOUR)
}
