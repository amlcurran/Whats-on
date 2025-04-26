package uk.co.amlcurran.social

import kotlinx.datetime.Instant
import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import org.joda.time.Days

class JodaCalculator : TimeCalculator {

    override fun plusHours(time: Instant, hours: Int): Instant {
        return Instant.fromEpochMilliseconds(getDateTime(time).plusHours(hours).millis)
    }

    override fun startOfToday(): Instant {
        return Instant.fromEpochMilliseconds(DateTime.now().withTimeAtStartOfDay().millis)
    }

    override fun getDays(time: Instant): Int {
        return Days.daysBetween(EPOCH, getDateTime(time)).days
    }

    override fun plusDays(days: Int, time: Instant): Instant {
        return Instant.fromEpochMilliseconds(getDateTime(time).plusDays(days).millis)
    }

    fun getDateTime(time: Instant): DateTime {
        return DateTime(time.toEpochMilliseconds(), DateTimeZone.getDefault())
    }

    companion object {
        private val EPOCH = DateTime(0, DateTimeZone.getDefault())
    }
}
