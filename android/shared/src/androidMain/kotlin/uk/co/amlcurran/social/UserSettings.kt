package uk.co.amlcurran.social

import android.content.Context
import androidx.core.content.edit
import androidx.preference.PreferenceManager

actual class UserSettings(context: Context) {

    private val preferences = PreferenceManager.getDefaultSharedPreferences(context)

    actual fun exclude(calendar: Calendar) {
        preferences.edit {
            putStringSet("excluded", excludedCalendars().inserting(calendar.id).toSet())
        }
    }

    private fun excludedCalendars() = preferences.getStringSet("excluded", emptySet()) ?: emptySet()

    actual fun include(calendar: Calendar) {
        preferences.edit {
            putStringSet("excluded", excludedCalendars().removing(calendar.id).toSet())
        }
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

    private fun hiddenEvents() = preferences.getStringSet("hidden_events", emptySet()) ?: emptySet()

    actual fun hide(eventId: String) {
        preferences.edit {
            putStringSet("hidden_events", hiddenEvents().inserting(eventId).toSet())
        }
    }

    actual fun shouldShowEvent(eventId: String): Boolean {
        return preferences.getStringSet("hidden_events", emptySet())!!.contains(eventId) == false
    }

    actual fun borderTimeStart() = preferences.getInt("startTime", 18).let { TimeOfDay.fromHours(it) }

    actual fun borderTimeEnd() = preferences.getInt("endTime", 23).let { TimeOfDay.fromHours(it) }

    actual fun updateStartTime(timeOfDay: TimeOfDay) = preferences.edit {
        putInt("startTime", timeOfDay.hoursInDay().toInt())
    }

    actual fun updateEndTime(timeOfDay: TimeOfDay) = preferences.edit {
        putInt("endTime", timeOfDay.hoursInDay().toInt())
    }

    actual fun showTentativeMeetings(): Boolean = preferences.getBoolean("showTentativeMeetings", false)

    actual fun shouldShowTentativeMeetings(boolean: Boolean) = preferences.edit {
        putBoolean("showTentativeMeetings", boolean)
    }

}