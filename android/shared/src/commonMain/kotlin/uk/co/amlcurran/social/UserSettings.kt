package uk.co.amlcurran.social

expect class UserSettings {

    fun exclude(calendar: Calendar)

    fun include(calendar: Calendar)

    fun shouldShow(it: CalendarItem): Boolean

    fun showEventsFrom(calendarId: String): Boolean

    fun hide(eventId: String)

    fun shouldShowEvent(eventId: String): Boolean

}