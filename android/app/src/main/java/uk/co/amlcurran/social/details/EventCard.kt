package uk.co.amlcurran.social.details

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Card
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import org.joda.time.format.DateTimeFormat
import uk.co.amlcurran.social.*

@Composable
@Preview
fun PreviewEventCard() {
    EventCard(
        event = Event(
            EventCalendarItem(
                "abc",
                "calendar",
                "A fun event",
                Timestamp(System.currentTimeMillis()),
                Timestamp(System.currentTimeMillis() - 60 * 60 * 1000 * 2)
            ), null)
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
                Timestamp(System.currentTimeMillis()),
                Timestamp(System.currentTimeMillis() - 60 * 60 * 1000 * 2)
            ), null)
    )
}

@Composable
fun EventCard(modifier: Modifier = Modifier, event: Event) {
    WhatsOnTheme {
        Card(
            modifier
                .background(
                    color = colorResource(id = R.color.colorSurface),
                    shape = RoundedCornerShape(8.dp)
                )
                .padding(16.dp)
        ) {
            Column(
                Modifier.background(colorResource(id = R.color.colorSurface))
            ) {
                Text(
                    event.item.title,
                    style = MaterialTheme.typography.body1,
                    color = colorResource(id = R.color.colorOnSurface),
                    modifier = Modifier.padding(bottom = 4.dp)
                )
                Text("From ${event.item.startTime.format(DateTimeFormat.shortTime())} to ${event.item.endTime.format(DateTimeFormat.shortTime())}", style = MaterialTheme.typography.body2)
            }
        }
    }
}