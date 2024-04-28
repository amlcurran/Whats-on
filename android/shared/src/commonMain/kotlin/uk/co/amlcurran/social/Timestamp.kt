package uk.co.amlcurran.social

data class Timestamp(val millis: Long)

fun Timestamp.plusDays(days: Int, timeCalculator: TimeCalculator): Timestamp {
    return timeCalculator.plusDays(days, this)
}

fun Timestamp.daysSinceEpoch(timeCalculator: TimeCalculator): Int {
    return timeCalculator.getDays(this)
}

fun Timestamp.plusHours(hours: Int, timeCalculator: TimeCalculator): Timestamp {
    return timeCalculator.plusHours(this, hours)
}

fun Timestamp.plusHoursOf(timeOfDay: TimeOfDay, timeCalculator: TimeCalculator): Timestamp {
    return timeCalculator.plusHours(this, timeOfDay.hoursInDay().toInt())
}
