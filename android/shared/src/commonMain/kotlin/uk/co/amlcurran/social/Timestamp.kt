package uk.co.amlcurran.social

class Timestamp(val millis: Long, private val timeCalculator: TimeCalculator) {

    fun plusDays(days: Int): Timestamp {
        return timeCalculator.plusDays(days, this)
    }

    fun daysSinceEpoch(): Int {
        return timeCalculator.getDays(this)
    }

    fun plusHours(hours: Int): Timestamp {
        return timeCalculator.plusHours(this, hours)
    }

    fun plusHoursOf(timeOfDay: TimeOfDay): Timestamp {
        return timeCalculator.plusHours(this, timeOfDay.hoursInDay().toInt())
    }

}
