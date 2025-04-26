package uk.co.amlcurran.social

import kotlinx.datetime.Instant
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormatter

fun Instant.format(formatter: DateTimeFormatter): String {
    return DateTime(toEpochMilliseconds()).toString(formatter)
}
