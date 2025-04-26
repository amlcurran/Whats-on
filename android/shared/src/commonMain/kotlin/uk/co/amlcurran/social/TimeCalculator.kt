package uk.co.amlcurran.social

import kotlinx.datetime.Instant

interface TimeCalculator {

    fun plusDays(days: Int, time: Instant): Instant

    fun getDays(time: Instant): Int

    fun plusHours(time: Instant, hours: Int): Instant

    fun startOfToday(): Instant

}
