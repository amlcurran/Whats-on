package uk.co.amlcurran.social

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.provider.CalendarContract
import android.provider.CalendarContract.Instances.CONTENT_URI

class AndroidEventsRepository(private val contentResolver: ContentResolver) : EventsRepository {

    private fun getCursor(searchStart: Timestamp, searchEnd: Timestamp): Cursor? {
        val builder = CONTENT_URI.buildUpon()
        ContentUris.appendId(builder, searchStart.millis)
        ContentUris.appendId(builder, searchEnd.millis)

        return contentResolver.query(builder.build(), CursorEventRepositoryAccessor.projection, "", null, null)
    }

    override fun getCalendarItems(nowTime: Timestamp, nextWeek: Timestamp, fivePm: TimeOfDay, elevenPm: TimeOfDay): List<Foo> {
        val calendarCursor = getCursor(nowTime, nextWeek)
        val accessor = CursorEventRepositoryAccessor(calendarCursor!!, JodaCalculator())
        val calendarItems = ArrayList<Foo>()
        while (accessor.nextItem()) {
            val title = accessor.title
            val eventId = accessor.eventIdentifier
            val calendarId = accessor.calendarId
            val time = accessor.startTime
            val endTime = accessor.endTime
            val allDay = accessor.allDay
            val attendingStatus = accessor.attendingStatus
            val deleted = accessor.isDeleted
            val startMinute = accessor.startMinuteInDay
            val endMinute = accessor.endMinuteInDay
            calendarItems.add(Foo(eventId, calendarId, title, time, endTime, allDay, attendingStatus, deleted, startMinute, endMinute))
        }
        calendarCursor.close()
        return calendarItems
    }

    override fun event(eventId: String): Event? {
        val cursor = contentResolver.query(ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId.toLong()),
                SINGLE_PROJECTION, null, null, null)
        val accessor = CursorEventRepositoryAccessor(cursor!!, JodaCalculator())
        return if (accessor.nextItem()) {
            val title = accessor.title
            val time = accessor.dtStartTime
            val endTime = accessor.dtEndTime
            val item = EventCalendarItem(eventId, "", title, time, endTime)
            val location = accessor.getString(CalendarContract.Events.EVENT_LOCATION)
            cursor.close()
            Event(item, location)
        } else {
            cursor.close()
            null
        }
    }

    override fun delete(eventId: String): Boolean {
        val contentUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId.toLong())
        return contentResolver.delete(contentUri, null, null) == 1
    }

    companion object {

        val SINGLE_PROJECTION = arrayOf(CalendarContract.Events.TITLE, CalendarContract.Events._ID, CalendarContract.Events.SELF_ATTENDEE_STATUS, CalendarContract.Events.EVENT_LOCATION, CalendarContract.Events.DTSTART, CalendarContract.Events.DTEND)
    }

}
