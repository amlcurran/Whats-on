package uk.co.amlcurran.social.add

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TimePicker
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddEventView() {
    val (title, setTitle) = remember {
        mutableStateOf("")
    }
    val fromState = rememberTimePickerState()
    val toState = rememberTimePickerState()
    val (showFromPicker, setShowFromPicker) = remember {
        mutableStateOf(false)
    }
    val focusRequester = remember {
        FocusRequester()
    }
    LaunchedEffect(key1 = Unit, block = {
        focusRequester.requestFocus()
    })
    Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
        OutlinedTextField(
            modifier = Modifier
                .fillMaxWidth()
                .focusRequester(focusRequester),
            value = title,
            onValueChange = setTitle,
            label = {
                Text("Name")
            })
        Row(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            if (showFromPicker) {
                Dialog(onDismissRequest = { setShowFromPicker(false) }) {
                    Surface {
                        TimePicker(state = fromState)
                    }
                }
            }
            Box(modifier = Modifier
                .weight(1f)
                .clickable { setShowFromPicker(true) }) {
                OutlinedTextField(
                    enabled = false,
                    value = title,
                    onValueChange = setTitle,
                    label = {
                        Text("From")
                    })
            }
            Text("to")
            OutlinedTextField(
                modifier = Modifier.weight(1f),
                value = title,
                onValueChange = setTitle,
                label = {
                    Text("To")
                })
        }
    }
}

@Composable
@Preview(showBackground = true, backgroundColor = 0xFFFFFF)
fun AEVP() {
    AddEventView()
}