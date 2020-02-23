package uk.co.amlcurran.social

import android.database.Cursor
import android.provider.CalendarContract

class CursorEventRepositoryAccessor(private val calendarCursor: Cursor, private val timeCalculator: TimeCalculator) : EventRepositoryAccessor {

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

    override fun getAllDay(): Boolean {
        return calendarCursor.getInt(allDayColumnIndex) != 0
    }

    override fun isDeleted(): Boolean {
        return calendarCursor.getInt(deletedColumnIndex) == 1
    }

    override fun getAttendingStatus(): Int {
        return calendarCursor.getInt(selfAttendanceColumnIndex)
    }

    override fun getStartMinuteInDay(): Int {
        return calendarCursor.getInt(startMinuteColumnIndex)
    }

    override fun getTitle(): String {
        return calendarCursor.getString(titleColumnIndex)
    }

    override fun getEventIdentifier(): String {
        return calendarCursor.getString(eventIdColumnIndex)
    }

    override fun nextItem(): Boolean {
        return calendarCursor.moveToNext()
    }

    override fun getStartTime(): Timestamp {
        val startMillis = calendarCursor.getLong(beginColumnIndex)
        return Timestamp(startMillis, timeCalculator)
    }

    override fun getEndTime(): Timestamp {
        val endMillis = calendarCursor.getLong(endColumnIndex)
        return Timestamp(endMillis, timeCalculator)
    }

    override fun getDtStartTime(): Timestamp {
        val startMillis = calendarCursor.getLong(dtStartColumnIndex)
        return Timestamp(startMillis, timeCalculator)
    }

    override fun getDtEndTime(): Timestamp {
        val endMillis = calendarCursor.getLong(dtEndColumnIndex)
        return Timestamp(endMillis, timeCalculator)
    }

    override fun getCalendarId(): String {
        return calendarCursor.getString(calendarIdColumnIndex)
    }

    override fun getEndMinuteInDay(): Int {
        return calendarCursor.getInt(endMinuteColumnIndex)
    }

    override fun getString(columnName: String): String {
        return calendarCursor.getString(calendarCursor.getColumnIndexOrThrow(columnName))
    }
}