package uk.co.amlcurran.social

import android.content.Context
import androidx.core.content.edit
import androidx.preference.PreferenceManager

class CalendarRepository(context: Context) {

    private val preferences = PreferenceManager.getDefaultSharedPreferences(context)

    fun exclude(calendar: Calendar) {
        preferences.edit {
            putStringSet("excluded", excludedCalendars().inserting(calendar.id))
        }
    }

    private fun excludedCalendars() = preferences.getStringSet("excluded", emptySet()) ?: emptySet()

    fun include(calendar: Calendar) {
        preferences.edit {
            putStringSet("excluded", excludedCalendars().removing(calendar.id))
        }
    }

    private fun <E> Set<E>.inserting(element: E): Set<E> = toMutableSet().apply {
        add(element)
    }

    private fun <E> Set<E>.removing(element: E): Set<E> = toMutableSet().apply {
        remove(element)
    }

    fun shouldShow(it: CalendarItem): Boolean {
        return if (it is EventCalendarItem) {
            !excludedCalendars().contains(it.calendarId)
        } else {
            true
        }
    }

    fun showEventsFrom(calendarId: String): Boolean {
        return !excludedCalendars().contains(calendarId)
    }

    private fun hiddenEvents() = preferences.getStringSet("hidden_events", emptySet()) ?: emptySet()

    fun hide(eventId: String) {
        preferences.edit {
            putStringSet("hidden_events", hiddenEvents().inserting(eventId))
        }
    }

    fun shouldShowEvent(eventId: String): Boolean {
        return preferences.getStringSet("hidden_events", emptySet())!!.contains(eventId) == false
    }

}