package uk.co.amlcurran.social

import platform.Foundation.NSUserDefaults

actual class CalendarRepository {

    private val preferences = NSUserDefaults.standardUserDefaults

    actual fun exclude(calendar: Calendar) {
        preferences.setObject(excludedCalendars().inserting(calendar.id).toList(), forKey = "excluded")
    }

    private fun excludedCalendars() = preferences.arrayForKey("excluded") ?: emptyList<String>()

    actual fun include(calendar: Calendar) {
        preferences.setObject(excludedCalendars().removing(calendar.id).toList(), "excluded")
    }

    actual fun shouldShow(it: CalendarItem): Boolean {
        return if (it is EventCalendarItem) {
            !excludedCalendars().contains(it.calendarId)
        } else {
            true
        }
    }

    actual fun showEventsFrom(calendarId: String): Boolean {
        return !excludedCalendars().contains(calendarId)
    }

    private fun hiddenEvents() = preferences.stringArrayForKey("hidden_events") ?: emptyList<String>()

    actual fun hide(eventId: String) {
        preferences.setObject(hiddenEvents().inserting(eventId), "hidden_events")
    }

    actual fun shouldShowEvent(eventId: String): Boolean {
        return preferences.stringArrayForKey("hidden_events")!!.contains(eventId) == false
    }

}