package uk.co.amlcurran.social

import android.content.Context
import androidx.core.content.edit
import androidx.preference.PreferenceManager

class CalendarRepository(context: Context) {

    private val preferences = PreferenceManager.getDefaultSharedPreferences(context)

    fun exclude(calendar: Calendar) {
        val excludedCalendars = preferences.getStringSet("excluded", emptySet()) ?: emptySet()
        preferences.edit {
            putStringSet("excluded", excludedCalendars.inserting(calendar.id))
        }
    }

    fun include(calendar: Calendar) {
        val excludedCalendars = preferences.getStringSet("excluded", emptySet()) ?: emptySet()
        preferences.edit {
            putStringSet("excluded", excludedCalendars.removing(calendar.id))
        }
    }

    private fun <E> Set<E>.inserting(element: E): Set<E> = toMutableSet().apply {
        add(element)
    }

    private fun <E> MutableSet<E>.removing(element: E): MutableSet<E> = toMutableSet().apply {
        remove(element)
    }

}