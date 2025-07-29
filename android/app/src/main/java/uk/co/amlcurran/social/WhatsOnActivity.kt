package uk.co.amlcurran.social

import android.Manifest
import android.content.Intent
import android.icu.util.TimeUnit
import android.os.Bundle
import android.provider.CalendarContract
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts.RequestMultiplePermissions
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.colorResource
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.lifecycle.lifecycleScope
import androidx.work.OneTimeWorkRequest
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequest
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import kotlinx.coroutines.launch
import uk.co.amlcurran.social.details.EventDetailActivity
import uk.co.amlcurran.social.widget.NextWeekWidget
import uk.co.amlcurran.social.widget.WidgetUpdateWorker
import uk.co.amlcurran.starlinginterview.AsyncContent
import java.time.Duration
import java.time.temporal.ChronoUnit
import java.time.temporal.TemporalUnit
import java.util.Calendar
import kotlin.time.DurationUnit
import kotlin.time.toDuration

class WhatsOnActivity : AppCompatActivity() {
    private val viewModel: EventListViewModel by viewModels()

    private val permissionRequest =
        (this as ComponentActivity).registerForActivityResult(RequestMultiplePermissions()) { permissions ->
            if (permissions.all { (_, granted) -> granted }) {
                lifecycleScope.launch {
                    viewModel.load()
                }
            }
        }

        private fun eventSelected(calendarItem: EventCalendarItem) {
            startActivity(EventDetailActivity.show(calendarItem, this@WhatsOnActivity))
        }

        private fun emptySelected(calendarItem: CalendarSlot) {
            val intent = Intent(Intent.ACTION_INSERT)
            intent.data = CalendarContract.Events.CONTENT_URI
            intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, calendarItem.startTimestamp.toEpochMilliseconds())
            intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, calendarItem.endTimestamp.toEpochMilliseconds())
//            startActivity(Intent(this@WhatsOnActivity, AddEventActivity::class.java))
            startActivity(intent)
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        lifecycleScope.launch {
            val manager = GlanceAppWidgetManager(this@WhatsOnActivity)
            val widget = NextWeekWidget()
            val glanceIds = manager.getGlanceIds(NextWeekWidget::class.java)
            glanceIds.forEach { glanceId ->
                widget.update(this@WhatsOnActivity, glanceId)
            }
            if (glanceIds.isNotEmpty()) {
                val dailyWorkRequest = WidgetUpdateWorker.buildWorkRequest()
                WorkManager.getInstance(applicationContext)
                    .enqueue(dailyWorkRequest)
            }
         }

        setContent {
            WhatsOnTheme {
                Scaffold(
                    topBar = {
                        Row(modifier = Modifier.statusBarsPadding()) {
                            HeaderView(modifier = Modifier.weight(1f))
                            IconButton(onClick = { SettingsActivity.start(this@WhatsOnActivity) },
                                colors = IconButtonDefaults.iconButtonColors(
                                    contentColor = MaterialTheme.colorScheme.onBackground
                                )) {
                                Icon(Icons.Outlined.Settings, contentDescription = "Settings")
                            }
                        }
                    },
                    containerColor = colorResource(id = R.color.background)
                ) { padding ->
                    val subscriptionsState = viewModel.source
                        .collectAsState()
                    AsyncContent(
                        state = subscriptionsState.value,
                        modifier = Modifier
                            .padding(padding)
                            .background(colorResource(id = R.color.background))
                    ) { calendarSource ->
                        SlotsView(calendarSource.slots, ::eventSelected, ::emptySelected)
                    }
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        reload()
    }

    private fun reload() {
        permissionRequest.launch(
            arrayOf(
                Manifest.permission.READ_CALENDAR,
                Manifest.permission.WRITE_CALENDAR
            )
        )
    }

}
