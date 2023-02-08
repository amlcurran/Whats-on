package uk.co.amlcurran.social

import android.view.View
import android.widget.TextView
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import org.joda.time.DateTime

import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter

internal class EventViewHolder(private val composeView: ComposeView, private val eventSelectedListener: WhatsOnAdapter.EventSelectedListener) : CalendarItemViewHolder<EventCalendarItem>(composeView) {

    override fun bind(item: EventCalendarItem) {
        composeView.setContent {
            WhatsOnTheme {
                EventView(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable {
                            eventSelectedListener.eventSelected(item, itemView)
                        },
                    event = item
                )
            }
        }
    }

}

fun Timestamp.format(formatter: DateTimeFormatter): String {
    return DateTime(millis).toString(formatter)
}
