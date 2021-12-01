package uk.co.amlcurran.social.details

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.res.fontResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import uk.co.amlcurran.social.Event
import uk.co.amlcurran.social.EventCalendarItem
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.Timestamp

@Composable
@Preview
fun PreviewEventCard() {
    EventCard(event = Event(
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
    EventCard(event = Event(
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
fun EventCard(modifier: Modifier = Modifier, isDark: Boolean = isSystemInDarkTheme(), event: Event) {
    MaterialTheme(
        typography = Typography(
            FontFamily(
                Font(R.font.opensanssemi, FontWeight.SemiBold),
                Font(R.font.opensansbold, FontWeight.Bold),
                Font(R.font.opensansreg, FontWeight.Medium),
            ),
            body1 = TextStyle(
                fontWeight = FontWeight.SemiBold
            )
        ),
        colors = if (isDark) darkColors() else lightColors()
    ) {
        Card(
            modifier
                .background(
                    color = MaterialTheme.colors.surface,
                    shape = RoundedCornerShape(8.dp)
                )
                .padding(8.dp)) {
            Column {
                Text(
                    event.item.title,
                    style = MaterialTheme.typography.body1,
                    color = colorResource(id = R.color.colorSecondary)
                )
                Text("From 5.30pm to 9.30pm", style = MaterialTheme.typography.body2)
            }
        }
    }
}