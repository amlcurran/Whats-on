package uk.co.amlcurran.social

expect class UserSettings {

    fun exclude(calendar: Calendar)

    fun include(calendar: Calendar)

    @Deprecated("use showEventsFrom instead")
    fun shouldShow(it: CalendarItem): Boolean

    fun showEventsFrom(calendarId: String): Boolean

    fun hide(eventId: String)

    fun shouldShowEvent(eventId: String): Boolean

    fun borderTimeStart(): TimeOfDay

    fun borderTimeEnd(): TimeOfDay

    fun updateStartTime(timeOfDay: TimeOfDay)

    fun updateEndTime(timeOfDay: TimeOfDay)

    fun showTentativeMeetings(): Boolean
    fun shouldShowTentativeMeetings(boolean: Boolean)

}