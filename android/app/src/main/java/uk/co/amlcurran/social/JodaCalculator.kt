package uk.co.amlcurran.social

import kotlinx.datetime.Instant
import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import org.joda.time.Days

class JodaCalculator : TimeCalculator {

    override fun plusHours(time: Timestamp, hours: Int): Timestamp {
        return Instant.fromEpochMilliseconds(getDateTime(time).plusHours(hours).millis)
    }

    override fun startOfToday(): Timestamp {
        return Instant.fromEpochMilliseconds(DateTime.now().withTimeAtStartOfDay().millis)
    }

    override fun getDays(time: Timestamp): Int {
        return Days.daysBetween(EPOCH, getDateTime(time)).days
    }

    override fun plusDays(days: Int, time: Timestamp): Timestamp {
        return Instant.fromEpochMilliseconds(getDateTime(time).plusDays(days).millis)
    }

    fun getDateTime(time: Timestamp): DateTime {
        return DateTime(time.toEpochMilliseconds(), DateTimeZone.getDefault())
    }

    companion object {
        private val EPOCH = DateTime(0, DateTimeZone.getDefault())
    }
}
