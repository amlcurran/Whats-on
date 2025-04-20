package uk.co.amlcurran.social

import android.app.Application
import android.content.Context
import android.database.Cursor
import android.os.Bundle
import android.provider.CalendarContract
import android.text.Spannable
import android.text.SpannableStringBuilder
import android.text.style.ClickableSpan
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TimePicker
import androidx.compose.material3.TimePickerState
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.tooling.preview.Preview
import androidx.fragment.app.Fragment
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.loader.app.LoaderManager
import androidx.loader.content.CursorLoader
import androidx.loader.content.Loader
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.flow
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import uk.co.amlcurran.social.databinding.SettingsBinding

const val PICKER_NONE = 0
const val PICKER_START = 1
const val PICKER_END = 2

fun JodaCalculator.printTime(
    timeOfDay: TimeOfDay,
    timeFormatter: DateTimeFormatter = DateTimeFormat.shortTime()
): String {
    return timeFormatter.print(toDateTime(timeOfDay))
}

fun JodaCalculator.toDateTime(timeOfDay: TimeOfDay): DateTime {
    return getDateTime(startOfToday().plusHoursOf(timeOfDay, this)
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TimeEditView() {
    val context = LocalContext.current
    val userSettings = remember {
        UserSettings(context)
    }
    val timeCalculator = remember {
        JodaCalculator()
    }
    val startTime = timeCalculator.toDateTime(userSettings.borderTimeStart())
    val endTime = timeCalculator.toDateTime(userSettings.borderTimeEnd())
    val startText = timeCalculator.printTime(userSettings.borderTimeStart())
    val endText = timeCalculator.printTime(userSettings.borderTimeEnd())
    val startState = rememberTimePickerState(startTime.hourOfDay)
    val endState = rememberTimePickerState(endTime.hourOfDay)
    val (showPicker, setShowPicker) = remember { mutableIntStateOf(PICKER_NONE) }
    val dismiss = { setShowPicker(PICKER_NONE) }
    val confirm = {
        if (showPicker == PICKER_START) {
            userSettings.updateStartTime(TimeOfDay.fromHours(startState.hour))
        } else {
            userSettings.updateEndTime(TimeOfDay.fromHours(endState.hour))
        }
    }
    val displayedState = if (showPicker == PICKER_START) startState else endState

    Column {
        if (showPicker != PICKER_NONE) {
            TimePickerDialog(dismiss, confirm, displayedState)
        }
        Text(text = "Show events from")
        Text(text = startText, modifier = Modifier.clickable {
            setShowPicker(PICKER_START)
        }, textDecoration = TextDecoration.Underline, color = MaterialTheme.colorScheme.primary)
        Text(text = "to")
        Text(text = endText, modifier = Modifier.clickable {
            setShowPicker(PICKER_START)
        }, textDecoration = TextDecoration.Underline, color = MaterialTheme.colorScheme.primary)
    }
}

@Composable
@OptIn(ExperimentalMaterial3Api::class)
fun TimePickerDialog(
    dismiss: () -> Unit,
    confirm: () -> Unit,
    displayedState: TimePickerState
) {
    WhatsOnTheme {
        AlertDialog(
            dismiss, dismissButton = {
                TextButton(onClick = dismiss) {
                    Text("Cancel")
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    confirm()
                    dismiss()
                }) {
                    Text("Confirm")
                }
            }, text = {
                Column {
                    TimePicker(displayedState)
                    Surface {
                        Text("Only the hour will be used to show events, not the minute")
                    }
                }
            })
    }
}

@Composable
fun TentativeMeetingsSwitch() {
    val context = LocalContext.current
    val userSettings = remember {
        UserSettings(context)
    }
    val (showTentative, setShowTentative) = remember {
        mutableStateOf(userSettings.showTentativeMeetings())
    }
    val (inAppAdd, setInAppAdd) = remember {
        mutableStateOf(userSettings.addInApp())
    }
    SideEffect {
        userSettings.shouldShowTentativeMeetings(showTentative)
        userSettings.shouldAddInApp(inAppAdd)
    }
    Row(verticalAlignment = Alignment.CenterVertically) {
        Text(
            modifier = Modifier.weight(1f),
            text = "Show events you've not replied to",
            style = MaterialTheme.typography.bodyMedium
        )
        Switch(checked = showTentative, onCheckedChange = setShowTentative)
    }
    Row(verticalAlignment = Alignment.CenterVertically) {
        Text(
            modifier = Modifier.weight(1f),
            text = "Add events in-app (beta)",
            style = MaterialTheme.typography.bodyMedium
        )
        Switch(checked = inAppAdd, onCheckedChange = setInAppAdd)
    }
}

class CalendarListViewModel(application: Application): AndroidViewModel(application) {

    private val userSettings = UserSettings(application)
    val calendar = flow {
        val cursor = application.contentResolver
            .query(CalendarContract.Calendars.CONTENT_URI, null, null, null, null)
        if (cursor != null) {
            val list = cursor.map {
                val calendarId = it.string(CalendarContract.Calendars._ID)
                Calendar(
                    calendarId,
                    it.string(CalendarContract.Calendars.NAME),
                    it.int(CalendarContract.Calendars.CALENDAR_COLOR),
                    userSettings.showEventsFrom(calendarId)
                )
            }
            this.emit(list)
        } else {
            throw NullPointerException()
        }
    }


}

@Composable
fun CalendarList(viewModel: CalendarListViewModel = viewModel()) {
    val (calendars, setCalendars) = remember {
        mutableStateOf(listOf<Calendar>())
    }
    LaunchedEffect(key1 = null) {
        viewModel.calendar
            .collectLatest {
                Log.d("TAG", "${calendars.size}")
                setCalendars(it)
            }
    }
    Column {
        for (calendar in calendars) {
            Text(calendar.name)
        }
    }
}

@Composable
fun SettingsView() {
    Column {
        TimeEditView()
        TentativeMeetingsSwitch()
        CalendarList()
    }
}

@Composable
@Preview(showBackground = true)
fun SettingsViewPreview() = WhatsOnTheme {
    SettingsView()
}


class SettingsFragment : Fragment() {

    private val userSettings: UserSettings by lazy { UserSettings(requireContext()) }
    private lateinit var binding: SettingsBinding

    private lateinit var delegate: SettingsDelegate

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = SettingsBinding.inflate(inflater, container, false)
        binding.settingsCompose.apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                WhatsOnTheme {
                    SettingsView()
                }
            }
        }
        return binding.root
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        binding.toolbar3.setNavigationOnClickListener { delegate.closeSettings() }
        val adapter = CalendarViewHolderAdapter(::calendarSelectionChange)
        binding.settingsList.adapter = adapter
        binding.settingsList.isNestedScrollingEnabled = false

        LoaderManager.getInstance(this)
            .initLoader(0, null, object : LoaderManager.LoaderCallbacks<Cursor> {
                override fun onCreateLoader(id: Int, args: Bundle?): Loader<Cursor> {
                    return CursorLoader(
                        requireContext(),
                        CalendarContract.Calendars.CONTENT_URI,
                        null,
                        null,
                        null,
                        null
                    )
                }

                override fun onLoadFinished(loader: Loader<Cursor>, data: Cursor?) {
                    if (data != null) {
                        val list = data.map {
                            val calendarId = it.string(CalendarContract.Calendars._ID)
                            Calendar(
                                calendarId,
                                it.string(CalendarContract.Calendars.NAME),
                                it.int(CalendarContract.Calendars.CALENDAR_COLOR),
                                userSettings.showEventsFrom(calendarId)
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

    private fun calendarSelectionChange(calendar: Calendar, enabled: Boolean) {
        if (enabled) {
            userSettings.include(calendar)
        } else {
            userSettings.exclude(calendar)
        }
    }

}

interface SettingsDelegate {
    fun closeSettings()
    fun onCalendarSettingsChanged()
}

private class FunctionSpan(val onClick: () -> Unit) : ClickableSpan() {
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