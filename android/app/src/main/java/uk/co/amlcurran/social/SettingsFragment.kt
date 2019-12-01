package uk.co.amlcurran.social

import android.app.TimePickerDialog
import android.content.Context
import android.database.Cursor
import android.os.Bundle
import android.provider.CalendarContract
import android.text.Spannable
import android.text.SpannableStringBuilder
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.core.text.buildSpannedString
import androidx.fragment.app.Fragment
import androidx.loader.app.LoaderManager
import androidx.loader.content.CursorLoader
import androidx.loader.content.Loader
import kotlinx.android.synthetic.main.settings.*
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter


class SettingsFragment: Fragment() {

    private val calendarRepository: CalendarRepository by lazy { CalendarRepository(requireContext()) }
    private val timeFormatter: DateTimeFormatter by lazy { DateTimeFormat.shortTime() }
    private val androidTimeRepository: AndroidTimeRepository by lazy { AndroidTimeRepository(requireContext()) }

    private lateinit var delegate: SettingsDelegate

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return container?.inflate(R.layout.settings)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        toolbar3.setNavigationOnClickListener { delegate.closeSettings() }
        val adapter = CalendarViewHolderAdapter(::calendarSelectionChange)
        settingsList.adapter = adapter
        settingsList.isNestedScrollingEnabled = false

        updateToFromText()
        settingsFromToTiming.isClickable = true
        settingsFromToTiming.movementMethod = LinkMovementMethod.getInstance()

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

    override fun onAttach(context: Context) {
        super.onAttach(context)
        delegate = context as SettingsDelegate
    }

    private fun updateToFromText() {
        settingsFromToTiming.text = buildSpannedString {
            val jodaCalculator = JodaCalculator()
            val startTime = jodaCalculator.getDateTime(jodaCalculator.startOfToday().plusHoursOf(androidTimeRepository.borderTimeStart()))
            val endTime = jodaCalculator.getDateTime(jodaCalculator.startOfToday().plusHoursOf(androidTimeRepository.borderTimeEnd()))
            val startText = timeFormatter.print(startTime)
            val endText = timeFormatter.print(endTime)
            append(getString(R.string.show_events_from_x_y, startText, endText))
            setSpan(startText, FunctionSpan { changeStartTime() })
            setSpan(endText, FunctionSpan { changeEndTime() })
        }
    }

    private fun changeStartTime() {
        val hoursInDay = androidTimeRepository.borderTimeStart().hoursInDay().toInt()
        TimePickerDialog(requireActivity(), ::updateStartTime, hoursInDay, 0, true).show()
    }

    @Suppress("UNUSED_PARAMETER")
    private fun updateStartTime(view: View, hourOfDay: Int, minute: Int) {
        androidTimeRepository.updateStartTime(TimeOfDay.fromHours(hourOfDay))
        updateToFromText()
    }

    private fun changeEndTime() {
        val hoursInDay = androidTimeRepository.borderTimeEnd().hoursInDay().toInt()
        TimePickerDialog(requireActivity(), ::updateEndTime, hoursInDay, 0, true).show()
    }

    @Suppress("UNUSED_PARAMETER")
    private fun updateEndTime(view: View, hourOfDay: Int, minute: Int) {
        androidTimeRepository.updateEndTime(TimeOfDay.fromHours(hourOfDay))
        updateToFromText()
    }

    private fun calendarSelectionChange(calendar: Calendar, enabled: Boolean) {
        if (enabled) {
            calendarRepository.include(calendar)
        } else {
            calendarRepository.exclude(calendar)
        }
    }

}

interface SettingsDelegate {
    fun closeSettings()
    fun onCalendarSettingsChanged()
}

private class FunctionSpan(val onClick: () -> Unit): ClickableSpan() {
    override fun onClick(widget: View) = onClick()

}

fun SpannableStringBuilder.setSpan(text: String, span: Any) {
    setSpan(span, indexOf(text), indexOf(text) + text.length, Spannable.SPAN_INCLUSIVE_EXCLUSIVE)
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