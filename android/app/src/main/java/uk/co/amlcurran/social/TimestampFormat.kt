package uk.co.amlcurran.social

import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormatter

fun Timestamp.format(formatter: DateTimeFormatter): String {
    return DateTime(millis).toString(formatter)
}
