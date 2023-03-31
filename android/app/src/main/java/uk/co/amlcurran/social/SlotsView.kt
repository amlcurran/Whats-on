package uk.co.amlcurran.social

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import org.joda.time.format.DateTimeFormat
import java.util.concurrent.TimeUnit

@Composable
fun SlotsView(calendarSlots: List<CalendarSlot>, onEventClick: (EventCalendarItem) -> Unit, onEmptySlotClick: (CalendarSlot) -> Unit) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(horizontal = 16.dp)
    ) {
        items(calendarSlots) { slot ->
            Text(
                slot.startTimestamp.format(DateTimeFormat.fullDate()),
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
                        items(slot.items) { item ->
                            EventView(event = item as EventCalendarItem,
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