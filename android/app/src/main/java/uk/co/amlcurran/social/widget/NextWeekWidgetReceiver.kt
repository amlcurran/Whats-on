package uk.co.amlcurran.social.widget

import android.content.Context
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ExitToApp
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
import androidx.glance.text.Text
import kotlinx.datetime.Clock
import org.joda.time.format.DateTimeFormat
import uk.co.amlcurran.social.AndroidEventsRepository
import uk.co.amlcurran.social.EventPredicates
import uk.co.amlcurran.social.EventsService
import uk.co.amlcurran.social.JodaCalculator
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.UserSettings
import uk.co.amlcurran.social.WhatsOnActivity
import uk.co.amlcurran.social.format

class NextWeekWidget: GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val eventsRepository: AndroidEventsRepository by lazy { AndroidEventsRepository(context.contentResolver) }
        val eventsService: EventsService by lazy { EventsService(eventsRepository, JodaCalculator(), UserSettings(context), EventPredicates(
            UserSettings(context)
        ).defaultPredicate) }
        val timestamp = Clock.System.now()
        val source = eventsService.getCalendarSource(14, timestamp)
        val formatter = DateTimeFormat.fullDate()
        provideContent {
            GlanceTheme {
                Scaffold {
                    Box(contentAlignment = Alignment.BottomEnd) {
                        LazyColumn {
                            items(source.slots) { slot ->
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
                                                text = "Nothing on"
                                            )
                                        }

                                        1 -> {
                                            Text(
                                                modifier = GlanceModifier.background(GlanceTheme.colors.surface)
                                                    .fillMaxWidth()
                                                    .padding(8.dp),
                                                maxLines = 1,
                                                text = slot.items.first().title
                                            )
                                        }

                                        else -> {
                                            Text(
                                                modifier = GlanceModifier.background(GlanceTheme.colors.surface)
                                                    .fillMaxWidth()
                                                    .padding(8.dp),
                                                maxLines = 1, text = "${slot.items.size} events"
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
    }

}

class NextWeekWidgetReceiver: GlanceAppWidgetReceiver() {

    override val glanceAppWidget: GlanceAppWidget
        get() = NextWeekWidget()

}