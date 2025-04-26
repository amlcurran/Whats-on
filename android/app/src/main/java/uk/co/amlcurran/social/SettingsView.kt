package uk.co.amlcurran.social

import android.app.Application
import android.database.Cursor
import android.provider.CalendarContract
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.selection.toggleable
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.flow
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter

const val PICKER_NONE = 0
const val PICKER_START = 1
const val PICKER_END = 2

fun JodaCalculator.printTime(
    timeOfDay: TimeOfDay,
    timeFormatter: DateTimeFormatter = DateTimeFormat.shortTime()
): String {
    return timeFormatter.print(toDateTime(timeOfDay))
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
        Row(modifier = Modifier.padding(bottom = 12.dp)) {
            Text(
                text = "Show events from ",
                style = MaterialTheme.typography.bodyMedium
            )
            Text(
                text = startText, modifier = Modifier.clickable {
                    setShowPicker(PICKER_START)
                },
                textDecoration = TextDecoration.Underline,
                color = MaterialTheme.colorScheme.primary,
                style = MaterialTheme.typography.bodyMedium
            )
            Text(
                text = " to ",
                style = MaterialTheme.typography.bodyMedium
            )
            Text(
                text = endText, modifier = Modifier.clickable {
                    setShowPicker(PICKER_END)
                },
                textDecoration = TextDecoration.Underline,
                color = MaterialTheme.colorScheme.primary,
                style = MaterialTheme.typography.bodyMedium
            )
        }
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
fun CalendarListInternal(calendars: List<Calendar>) {
    val context = LocalContext.current
    val userSettings = remember { UserSettings(context) }
    Column {
        Spacer(Modifier.height(16.dp))
        Text("Show events from calendars:", color = MaterialTheme.colorScheme.onSurfaceVariant)
        for (calendar in calendars) {
            Row(
                Modifier.fillMaxWidth()
                    .toggleable(
                        value = calendar.isSelected,
                        onValueChange = {
                            if (it) {
                                userSettings.include(calendar)
                            } else {
                                userSettings.exclude(calendar)
                            }
                        },
                        role = Role.Checkbox
                    )
                    .padding(vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Checkbox(
                    checked = calendar.isSelected,
                    colors = CheckboxDefaults.colors(
                        checkedColor = Color(calendar.color)
                    ),
                    onCheckedChange = null
                )
                Text(
                    text = calendar.name,
                    style = MaterialTheme.typography.bodyLarge,
                    modifier = Modifier.padding(start = 16.dp)
                )
            }
        }
        if (calendars.isEmpty()) {
            Text("No calendars found.", Modifier.padding(16.dp).fillMaxWidth(),
                textAlign = TextAlign.Center)
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
    CalendarListInternal(calendars)
}

@Composable
fun SettingsViewInternal(modifier: Modifier = Modifier, CalendarListComposable: @Composable () -> Unit = { CalendarList() }) {
    Column(modifier.padding(16.dp)) {
        TimeEditView()
        TentativeMeetingsSwitch()
        CalendarListComposable()
    }
}

@Composable
fun SettingsView(modifier: Modifier) {
    SettingsViewInternal(modifier) {
        CalendarList()
    }
}

@Composable
@Preview(showBackground = true)
fun SettingsViewPreview() = WhatsOnTheme {
    SettingsViewInternal {
        CalendarListInternal(listOf(
            Calendar("abcd", "Work", android.graphics.Color.BLUE, false),
            Calendar("abcd", "Personal", android.graphics.Color.GREEN, true),
        ))
    }
}

@Composable
@Preview(showBackground = true)
fun SettingsViewPreviewEmpty() = WhatsOnTheme {
    SettingsViewInternal {
        CalendarListInternal(listOf())
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