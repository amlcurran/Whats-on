package uk.co.amlcurran.social

import kotlinx.datetime.Instant

fun Instant.plusDays(
    days: Int,
    timeCalculator: TimeCalculator
): Instant {
    return timeCalculator.plusDays(days, this)
}

fun Instant.daysSinceEpoch(timeCalculator: TimeCalculator): Int {
    return timeCalculator.getDays(this)
}

fun Instant.plusHoursOf(
    timeOfDay: TimeOfDay,
    timeCalculator: TimeCalculator
): Instant {
    return timeCalculator.plusHours(this, timeOfDay.hoursInDay().toInt())
}
