package uk.co.amlcurran.social

import java.util.concurrent.TimeUnit

class TimeOfDay private constructor(private val millis: Long) {

    fun hoursInDay(): Long {
        return TimeUnit.MILLISECONDS.toHours(millis)
    }

    fun minutesInDay(): Long {
        return TimeUnit.MILLISECONDS.toMinutes(millis)
    }

    companion object {

        fun fromHours(hours: Int): TimeOfDay {
            return TimeOfDay(TimeUnit.HOURS.toMillis(hours.toLong()))
        }

    }
}
