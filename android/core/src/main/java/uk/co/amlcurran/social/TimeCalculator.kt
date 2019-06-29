package uk.co.amlcurran.social

interface TimeCalculator {

    fun plusDays(days: Int, time: Timestamp): Timestamp

    fun getDays(time: Timestamp): Int

    fun plusHours(time: Timestamp, hours: Int): Timestamp

    fun startOfToday(): Timestamp

}
