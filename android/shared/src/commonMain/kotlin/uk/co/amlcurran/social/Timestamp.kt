package uk.co.amlcurran.social

import kotlinx.datetime.Instant

typealias Timestamp = Instant

fun Timestamp.plusDays(days: Int, timeCalculator: TimeCalculator): Timestamp {
    return timeCalculator.plusDays(days, this)
}

fun Timestamp.daysSinceEpoch(timeCalculator: TimeCalculator): Int {
    return timeCalculator.getDays(this)
}

fun Timestamp.plusHoursOf(timeOfDay: TimeOfDay, timeCalculator: TimeCalculator): Timestamp {
    return timeCalculator.plusHours(this, timeOfDay.hoursInDay().toInt())
}
