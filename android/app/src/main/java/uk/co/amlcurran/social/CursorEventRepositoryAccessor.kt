package uk.co.amlcurran.social

import android.database.Cursor
import android.provider.CalendarContract

class CursorEventRepositoryAccessor(private val calendarCursor: Cursor) {

    private val titleColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.TITLE) }
    private val dtStartColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.DTSTART) }
    private val dtEndColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.DTEND) }
    private val beginColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.BEGIN) }
    private val endColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.END) }
    private val eventIdColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.EVENT_ID) }
    private val calendarIdColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.CALENDAR_ID) }
    private val allDayColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.ALL_DAY) }
    private val selfAttendanceColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.SELF_ATTENDEE_STATUS) }
    private val deletedColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Events.DELETED) }
    private val startMinuteColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.START_MINUTE) }
    private val endMinuteColumnIndex: Int by lazy { calendarCursor.getColumnIndexOrThrow(CalendarContract.Instances.END_MINUTE) }

    companion object {
        val projection = arrayOf(
            CalendarContract.Events.TITLE,
            CalendarContract.Instances.BEGIN,
            CalendarContract.Instances.END,
            CalendarContract.Instances.EVENT_ID,
            CalendarContract.Instances.CALENDAR_ID,
            CalendarContract.Instances.ALL_DAY,
            CalendarContract.Instances.SELF_ATTENDEE_STATUS,
            CalendarContract.Instances.START_MINUTE,
            CalendarContract.Instances.END_MINUTE,
            CalendarContract.Events.DELETED
        )
    }

    val allDay: Boolean
        get() {
            return calendarCursor.getInt(allDayColumnIndex) != 0
        }

    val isDeleted: Boolean
        get() {
            return calendarCursor.getInt(deletedColumnIndex) == 1
        }

    val attendingStatus: Int
        get() {
            return calendarCursor.getInt(selfAttendanceColumnIndex)
        }

    val startMinuteInDay: Int
        get() {
            return calendarCursor.getInt(startMinuteColumnIndex)
        }

    val title: String
        get() {
            return calendarCursor.getString(titleColumnIndex)
        }

    val eventIdentifier: String
        get() {
            return calendarCursor.getString(eventIdColumnIndex)
        }

    fun nextItem(): Boolean {
        return calendarCursor.moveToNext()
    }

    val startTime: Timestamp
        get() {
            val startMillis = calendarCursor.getLong(beginColumnIndex)
            return Timestamp.fromEpochMilliseconds(startMillis)
        }

    val endTime: Timestamp
        get() {
            val endMillis = calendarCursor.getLong(endColumnIndex)
            return Timestamp.fromEpochMilliseconds(endMillis)
        }

    val dtStartTime: Timestamp
        get() {
            val startMillis = calendarCursor.getLong(dtStartColumnIndex)
            return Timestamp.fromEpochMilliseconds(startMillis)
        }

    val dtEndTime: Timestamp
        get() {
            val endMillis = calendarCursor.getLong(dtEndColumnIndex)
            return Timestamp.fromEpochMilliseconds(endMillis)
        }

    val calendarId: String
        get() {
            return calendarCursor.getString(calendarIdColumnIndex)
        }

    val endMinuteInDay: Int
        get() {
            return calendarCursor.getInt(endMinuteColumnIndex)
        }

    fun getString(columnName: String): String {
        return calendarCursor.getString(calendarCursor.getColumnIndexOrThrow(columnName))
    }
}