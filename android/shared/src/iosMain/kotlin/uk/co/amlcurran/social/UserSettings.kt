package uk.co.amlcurran.social

import platform.Foundation.NSUserDefaults
import platform.darwin.NSInteger

actual class UserSettings {

    private val preferences = NSUserDefaults.standardUserDefaults

    actual fun exclude(calendar: Calendar) {
        preferences.setObject(excludedCalendars().inserting(calendar.id).toList(), forKey = "excluded")
    }

    private fun excludedCalendars() = preferences.arrayForKey("excluded") ?: emptyList<String>()

    actual fun include(calendar: Calendar) {
        preferences.setObject(excludedCalendars().removing(calendar.id).toList(), "excluded")
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

    actual fun borderTimeStart() = preferences
        .nullableIntegerForKey("startTime")
        .let { TimeOfDay.fromHours(it ?: 18) }

    actual fun borderTimeEnd() = preferences
        .nullableIntegerForKey("endTime")
        .let { TimeOfDay.fromHours(it ?: 23) }

    actual fun updateStartTime(timeOfDay: TimeOfDay) {
        preferences.setInteger(timeOfDay.hoursInDay(), "startTime")
    }

    actual fun updateEndTime(timeOfDay: TimeOfDay) {
        preferences.setInteger(timeOfDay.hoursInDay(), "endTime")
    }

    private fun NSUserDefaults.nullableIntegerForKey(key: String): Int? {
        return if (objectForKey(key) != null) {
            integerForKey(key).toInt()
        } else {
            null
        }
    }

}