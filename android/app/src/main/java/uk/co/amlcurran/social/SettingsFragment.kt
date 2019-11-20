package uk.co.amlcurran.social

import android.database.Cursor
import android.os.Bundle
import android.provider.CalendarContract
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.fragment.app.Fragment
import androidx.loader.app.LoaderManager
import androidx.loader.content.CursorLoader
import androidx.loader.content.Loader
import kotlinx.android.synthetic.main.settings.*


class SettingsFragment: Fragment() {

    private val calendarRepository: CalendarRepository by lazy { CalendarRepository(requireContext()) }

    lateinit var onNavigationTapped: () -> Unit

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return container?.inflate(R.layout.settings)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        toolbar3.setNavigationOnClickListener { onNavigationTapped() }
        val adapter = CalendarViewHolderAdapter(::calendarSelectionChange)
        settingsList.adapter = adapter

        LoaderManager.getInstance(this).initLoader(0, null, object : LoaderManager.LoaderCallbacks<Cursor> {
            override fun onCreateLoader(id: Int, args: Bundle?): Loader<Cursor> {
                return CursorLoader(requireContext(), CalendarContract.Calendars.CONTENT_URI, null, null, null, null)
            }

            override fun onLoadFinished(loader: Loader<Cursor>, data: Cursor?) {
                if (data != null) {
                    val list = data.map {
                        val calendarId = it.string(CalendarContract.Calendars._ID)
                        Calendar(
                            calendarId,
                            it.string(CalendarContract.Calendars.NAME),
                            it.int(CalendarContract.Calendars.CALENDAR_COLOR),
                            calendarRepository.showEventsFrom(calendarId)
                        )
                    }
                    adapter.update(list)
                }
            }

            override fun onLoaderReset(loader: Loader<Cursor>) {
                adapter.update(emptyList())
            }

        })
    }

    private fun calendarSelectionChange(calendar: Calendar, enabled: Boolean) {
        if (enabled) {
            calendarRepository.include(calendar)
        } else {
            calendarRepository.exclude(calendar)
        }
    }

}

private fun Cursor.string(columnName: String): String = getString(getColumnIndexOrThrow(columnName))

private fun Cursor.int(columnName: String): Int = getInt(getColumnIndexOrThrow(columnName))

private fun <T> Cursor.map(function: (Cursor) -> T): List<T> {
    val list = mutableListOf<T>()
    while (moveToNext()) {
        list.add(function(this))
    }
    return list
}

internal fun ViewGroup.inflate(@LayoutRes layout: Int, insert: Boolean = false): View =
    LayoutInflater.from(context).inflate(layout, this, insert)

data class Calendar(val id: String, val name: String, val color: Int, val isSelected: Boolean)