package uk.co.amlcurran.social.details

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.datetime.Instant
import org.joda.time.format.DateTimeFormat
import uk.co.amlcurran.social.Event
import uk.co.amlcurran.social.EventCalendarItem
import uk.co.amlcurran.social.WhatsOnTheme
import uk.co.amlcurran.social.format

@Composable
@Preview
fun PreviewEventCard() {
    EventCard(
        event = Event(
            EventCalendarItem(
                "abc",
                "calendar",
                "A fun event",
                Instant.fromEpochMilliseconds(System.currentTimeMillis()),
                Instant.fromEpochMilliseconds(System.currentTimeMillis() - 60 * 60 * 1000 * 2),
                emptyList()
            ), null
        )
    )
}

@Composable
@Preview(uiMode = UI_MODE_NIGHT_YES)
fun DarkPreviewEventCard() {
    EventCard(
        event = Event(
            EventCalendarItem(
                "abc",
                "calendar",
                "A fun event",
                Instant.fromEpochMilliseconds(System.currentTimeMillis()),
                Instant.fromEpochMilliseconds(System.currentTimeMillis() - 60 * 60 * 1000 * 2),
                emptyList()
            ), null
        )
    )
}

@Composable
fun EventCard(modifier: Modifier = Modifier, event: Event) {
    WhatsOnTheme {
        Column(
            modifier
                .background(
                    color = MaterialTheme.colorScheme.surface,
                    shape = RoundedCornerShape(8.dp)
                )
                .padding(16.dp)
        ) {
            Text(
                event.item.title,
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface,
                modifier = Modifier.padding(bottom = 2.dp)
            )
            Text(
                "From ${event.item.startTime.format(DateTimeFormat.shortTime())} to ${
                    event.item.endTime.format(
                        DateTimeFormat.shortTime()
                    )
                }",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}