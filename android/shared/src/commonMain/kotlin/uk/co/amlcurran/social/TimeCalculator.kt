package uk.co.amlcurran.social

import kotlinx.datetime.Instant

interface TimeCalculator {

    fun getDays(time: Instant): Int

    fun startOfToday(): Instant

}
