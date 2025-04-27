package uk.co.amlcurran.social.widget

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.ImageProvider
import androidx.glance.action.actionStartActivity
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.components.Scaffold
import androidx.glance.appwidget.components.SquareIconButton
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.appwidget.lazy.items
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.preview.ExperimentalGlancePreviewApi
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import org.joda.time.format.DateTimeFormat
import uk.co.amlcurran.social.AndroidEventsRepository
import uk.co.amlcurran.social.CalendarSlot
import uk.co.amlcurran.social.EventPredicates
import uk.co.amlcurran.social.EventsService
import uk.co.amlcurran.social.JodaCalculator
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.UserSettings
import uk.co.amlcurran.social.WhatsOnActivity
import uk.co.amlcurran.social.format
import uk.co.amlcurran.social.util.previewSlots
import java.util.concurrent.TimeUnit


@Composable
private fun NextWeek(
    source: List<CalendarSlot>,
) {
    val formatter = remember { DateTimeFormat.fullDate() }
    GlanceTheme {
        Scaffold {
            Box(contentAlignment = Alignment.BottomEnd) {
                LazyColumn {
                    items(source, { it.startTimestamp.epochSeconds }) { slot ->
                        Column(GlanceModifier.padding(bottom = 8.dp)) {
                            Text(
                                slot.startTimestamp.format(formatter),
                            )
                            when (slot.items.count()) {
                                0 -> {
                                    Text(
                                        modifier = GlanceModifier
                                            .fillMaxWidth()
                                            .padding(8.dp),
                                        maxLines = 1,
                                        style = TextStyle(
                                            color = GlanceTheme.colors.onBackground
                                        ),
                                        text = "Nothing on"
                                    )
                                }

                                1 -> {
                                    Text(
                                        modifier = GlanceModifier
                                            .background(GlanceTheme.colors.surface)
                                            .fillMaxWidth()
                                            .padding(8.dp),
                                        maxLines = 1,
                                        style = TextStyle(
                                            color = GlanceTheme.colors.onSurface
                                        ),
                                        text = slot.items.first().title
                                    )
                                }

                                else -> {
                                    Text(
                                        modifier = GlanceModifier.background(GlanceTheme.colors.surface)
                                            .fillMaxWidth()
                                            .padding(8.dp),
                                        style = TextStyle(
                                            color = GlanceTheme.colors.onSurface
                                        ),
                                        maxLines = 1,
                                        text = "${slot.items.size} events"
                                    )
                                }
                            }
                        }
                    }
                }
                Box(modifier = GlanceModifier.padding(bottom = 12.dp)) {
                    SquareIconButton(
                        modifier = GlanceModifier.size(48.dp),
                        imageProvider = ImageProvider(R.drawable.baseline_open_in_new_24),
                        contentDescription = "Open What's on",
                        onClick = actionStartActivity<WhatsOnActivity>()
                    )
                }
            }
        }
    }
}

class NextWeekWidget: GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val eventsRepository: AndroidEventsRepository by lazy { AndroidEventsRepository(context.contentResolver) }
        val eventsService: EventsService by lazy { EventsService(eventsRepository, JodaCalculator(), UserSettings(context), EventPredicates(
            UserSettings(context)
        ).defaultPredicate) }
        val timestamp = Clock.System.now()
        val source = eventsService.getCalendarSource(14, timestamp)
        provideContent {
            NextWeek(source.slots)
        }
    }

}

class NextWeekWidgetReceiver: GlanceAppWidgetReceiver() {

    override val glanceAppWidget: GlanceAppWidget
        get() = NextWeekWidget()

}

@OptIn(ExperimentalGlancePreviewApi::class)
@androidx.glance.preview.Preview
@Composable
fun NextWeekPreview() {
    NextWeek(previewSlots)
}