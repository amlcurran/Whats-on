package uk.co.amlcurran.social

import kotlinx.datetime.Instant
import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import org.joda.time.Days

class JodaCalculator : TimeCalculator {

    override fun startOfToday(): Instant {
        return Instant.fromEpochMilliseconds(DateTime.now().withTimeAtStartOfDay().millis)
    }

    override fun getDays(time: Instant): Int {
        return Days.daysBetween(EPOCH, getDateTime(time)).days
    }

    private fun getDateTime(time: Instant): DateTime {
        return DateTime(time.toEpochMilliseconds(), DateTimeZone.getDefault())
    }

    fun toDateTime(timeOfDay: TimeOfDay): DateTime {
        return getDateTime(startOfToday().plusHoursOf(timeOfDay)
        )
    }

    companion object {
        private val EPOCH = DateTime(0, DateTimeZone.getDefault())
    }
}
