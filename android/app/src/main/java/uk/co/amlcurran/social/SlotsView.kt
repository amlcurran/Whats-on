package uk.co.amlcurran.social

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import org.joda.time.format.DateTimeFormat
import java.util.concurrent.TimeUnit

@Composable
fun SlotsView(calendarSlots: List<CalendarSlot>, onEventClick: (EventCalendarItem) -> Unit, onEmptySlotClick: (CalendarSlot) -> Unit) {
    val formatter = remember {
        DateTimeFormat.fullDate()
    }
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(horizontal = 16.dp)
    ) {
        items(calendarSlots, key = { it.startTimestamp.millis }) { slot ->
            Text(
                slot.startTimestamp.format(formatter),
                color = MaterialTheme.colors.onBackground,
                style = MaterialTheme.typography.subtitle2,
                modifier = Modifier.padding(
                    bottom = 8.dp
                )
            )
            if (slot.isEmpty) {
                EmptyView(modifier = Modifier
                    .clickable { onEmptySlotClick(slot) }
                    .fillMaxWidth()
                )
            } else if (slot.items.count() == 1) {
                // This is dodgy as heck
                val event = slot.firstItem as EventCalendarItem
                EventView(event = event,
                    modifier = Modifier
                        .clickable { onEventClick(event) }
                        .fillMaxWidth()
                )
            } else {
                BoxWithConstraints {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(16.dp),
                        contentPadding = PaddingValues(horizontal = 0.dp)
                    ) {
                        items(slot.items, key = { it.eventId }) { item ->
                            EventView(event = item,
                                modifier = Modifier
                                    .clickable { onEventClick(item) }
                                    .width(maxWidth.times(0.8f))
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
@Preview(showBackground = true)
fun SlotsViewPreview() = WhatsOnTheme {
    SlotsView(calendarSlots = (0 until 10).map {
        val start = it * TimeUnit.DAYS.toMillis(1)
        CalendarSlot(
            mutableListOf(),
            Timestamp(start),
            Timestamp(start + TimeUnit.HOURS.toMillis(3))
        )
    }, onEventClick = {}, onEmptySlotClick = {})
}