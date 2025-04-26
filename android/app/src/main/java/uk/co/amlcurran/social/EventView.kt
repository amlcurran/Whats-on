package uk.co.amlcurran.social

import android.os.Build
import androidx.annotation.RequiresApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import org.joda.time.format.DateTimeFormat
import java.time.Instant

@Composable
fun EventView(modifier: Modifier = Modifier, event: EventCalendarItem) {
    val formatter = remember {
        DateTimeFormat.shortTime()
    }
    Column(
        modifier
            .background(colorResource(id = R.color.colorSurface), shape = RoundedCornerShape(8.dp))
            .padding(16.dp)) {
        Text(
            text = event.title,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurface
        )
        Text(
            text = stringResource(
                id = R.string.event_from,
                event.startTime.format(formatter)
            ),
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@RequiresApi(Build.VERSION_CODES.O)
@Composable
@Preview(showBackground = true)
fun EventViewPreview() {
    Box(Modifier.padding(16.dp)) {
        EventView(
            event = EventCalendarItem(
                "abcd",
                "defg",
                "An exciting event",
                Timestamp(Instant.now().minusMillis(40000L).toEpochMilli()),
                Timestamp(Instant.now().toEpochMilli()),
                emptyList()
            )
        )
    }
}