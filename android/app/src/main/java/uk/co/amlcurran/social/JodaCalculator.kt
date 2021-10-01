package uk.co.amlcurran.social

import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import org.joda.time.Days

class JodaCalculator : TimeCalculator {

    override fun plusHours(time: Timestamp, hours: Int): Timestamp {
        return Timestamp(getDateTime(time).plusHours(hours).millis)
    }

    override fun startOfToday(): Timestamp {
        return Timestamp(DateTime.now().withTimeAtStartOfDay().millis)
    }

    override fun getDays(time: Timestamp): Int {
        return Days.daysBetween(EPOCH, getDateTime(time)).days
    }

    override fun plusDays(days: Int, time: Timestamp): Timestamp {
        return Timestamp(getDateTime(time).plusDays(days).millis)
    }

    fun getDateTime(time: Timestamp): DateTime {
        return DateTime(time.millis, DateTimeZone.getDefault())
    }

    companion object {
        private val EPOCH = DateTime(0, DateTimeZone.getDefault())
    }
}
