package uk.co.amlcurran.social

import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.LocationOn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.SuggestionChip
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun EmptyView(modifier: Modifier = Modifier, editMode: Boolean = false) {
    val (isEditMode, setEditMode) = remember { mutableStateOf(editMode) }
    val color = colorResource(id = R.color.empty_color)
    val density = LocalContext.current.resources.displayMetrics.density
    val context = LocalContext.current
    val userSettings = remember { UserSettings(context) }
    Box(
        modifier
            .let {
                if (userSettings.addInApp()) {
                    it.clickable { setEditMode(true) }
                } else {
                    it
                }
            }
            .animateContentSize()
            .drawBehind {
                drawRoundRect(
                    color = color,
                    style = Stroke(
                        density * 2f,
                        pathEffect = PathEffect.dashPathEffect(
                            floatArrayOf(
                                8f * density,
                                4f * density
                            )
                        )
                    ),
                    cornerRadius = CornerRadius(x = density * 8f, y = density * 8f)
                )
            }
    ) {
        if (isEditMode) {
            EditMode(setEditMode)
        } else {
            Text(
                "Nothing on",
                modifier = Modifier
                    .padding(16.dp),
                style = MaterialTheme.typography.bodyMedium,
                color = colorResource(id = R.color.empty_color)
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun EditMode(
    setEditMode: (Boolean) -> Unit
) {
    val (title, setTitle) = remember { mutableStateOf("") }
    val context = LocalContext.current
    val userSettings = remember { UserSettings(context) }
    val calculator = remember { JodaCalculator() }
    val startTime = remember { mutableStateOf(userSettings.borderTimeStart()) }
    val endTime = remember { mutableStateOf(userSettings.borderTimeEnd()) }
    val startFormatted = calculator.printTime(startTime.value)
    val endFormatted = calculator.printTime(endTime.value)
    Column {
        TextField(
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(
                errorBorderColor = Color.Transparent,
                disabledBorderColor = Color.Transparent,
                focusedBorderColor = Color.Transparent,
                unfocusedBorderColor = Color.Transparent,
            ),
            value = title,
            onValueChange = { setTitle(it) },
            placeholder = { Text("Title") }
        )
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            val startState = rememberTimePickerState(calculator.toDateTime(startTime.value).hourOfDay)
            val (showStart, setShowStart) = remember { mutableStateOf(false) }
            SuggestionChip({
                setShowStart(true)
            }, label = {
                Text("From $startFormatted")
            })
            if (showStart) {
                TimePickerDialog({
                    setShowStart(false)
                }, {
                    startTime.value = TimeOfDay.fromHours(startState.hour)
                }, startState)
            }
            SuggestionChip({

            }, label = {
                Text("To $endFormatted")
            })
            SuggestionChip({

            }, label = {
                Text("Location")
            }, icon = {
                Icon(
                    Icons.Rounded.LocationOn,
                    modifier = Modifier.size(18.dp),
                    contentDescription = null
                )
            })
        }
        Row(horizontalArrangement = Arrangement.End, modifier = Modifier.fillMaxWidth()) {
            TextButton({
                setEditMode(false)
            }) { Text("Cancel") }
            TextButton({
                setEditMode(false)
            }) { Text("Add") }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun EmptyViewPreview() {
    EmptyView(Modifier
        .fillMaxWidth()
        .padding(16.dp))
}

@Preview(showBackground = true)
@Composable
fun EmptyViewPreviewEdit() {
    EmptyView(Modifier
        .fillMaxWidth()
        .padding(16.dp), editMode = true)
}
