package uk.co.amlcurran.social

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.provider.CalendarContract
import android.provider.CalendarContract.Instances.*

import java.util.ArrayList

class AndroidEventsRepository(private val contentResolver: ContentResolver) : EventsRepository {

    private fun getCursor(fivePm: TimeOfDay, elevenPm: TimeOfDay, searchStart: Timestamp, searchEnd: Timestamp): Cursor? {
        val builder = CONTENT_URI.buildUpon()
        ContentUris.appendId(builder, searchStart.millis)
        ContentUris.appendId(builder, searchEnd.millis)

        val endsBefore = "$END_MINUTE < ${fivePm.minutesInDay()}"
        val startsAfter = "$START_MINUTE > ${elevenPm.minutesInDay()}"
        val selection = "(NOT (${endsBefore} OR ${startsAfter})) " +
                "AND $SELF_ATTENDEE_STATUS <> $STATUS_CANCELED " +
                "AND $ALL_DAY == 0"

        return contentResolver.query(builder.build(), PROJECTION, selection, null, null)
    }

    override fun getCalendarItems(nowTime: Timestamp, nextWeek: Timestamp, fivePm: TimeOfDay, elevenPm: TimeOfDay): List<CalendarItem> {
        val calendarCursor = getCursor(fivePm, elevenPm, nowTime, nextWeek)
        val accessor = CursorEventRepositoryAccessor(calendarCursor!!, JodaCalculator())
        val calendarItems = ArrayList<CalendarItem>()
        while (accessor.nextItem()) {
            val title = accessor.title
            val eventId = accessor.eventIdentifier
            val time = accessor.startTime
            val endTime = accessor.endTime
            calendarItems.add(EventCalendarItem(eventId, title, time, endTime))
        }
        calendarCursor.close()
        return calendarItems
    }

    override fun event(eventId: String): Event? {
        val cursor = contentResolver.query(ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId.toLong()),
                SINGLE_PROJECTION, null, null, null)
        val accessor = CursorEventRepositoryAccessor(cursor!!, JodaCalculator())
        if (accessor.nextItem()) {
            val title = accessor.title
            val time = accessor.startTime
            val endTime = accessor.endTime
            val item = EventCalendarItem(eventId, title, time, endTime)
            val location = accessor.getString(CalendarContract.Events.EVENT_LOCATION)
            cursor.close()
            return Event(item, location)
        } else {
            cursor.close()
            return null
        }
    }

    companion object {

        val PROJECTION = arrayOf(CalendarContract.Events.TITLE, START_DAY, CalendarContract.Events.SELF_ATTENDEE_STATUS, CalendarContract.Events.DTSTART, CalendarContract.Events.DTEND, EVENT_ID)
        val SINGLE_PROJECTION = arrayOf(CalendarContract.Events.TITLE, CalendarContract.Events.SELF_ATTENDEE_STATUS, CalendarContract.Events.EVENT_LOCATION, CalendarContract.Events.DTSTART, CalendarContract.Events.DTEND)
    }

}
