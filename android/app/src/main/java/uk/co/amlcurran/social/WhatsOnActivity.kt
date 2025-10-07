package uk.co.amlcurran.social

import android.Manifest
import android.app.Activity
import android.content.Intent
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
import androidx.compose.material3.adaptive.ExperimentalMaterial3AdaptiveApi
import androidx.compose.material3.adaptive.layout.AnimatedPane
import androidx.compose.material3.adaptive.layout.ListDetailPaneScaffoldRole
import androidx.compose.material3.adaptive.navigation.NavigableListDetailPaneScaffold
import androidx.compose.material3.adaptive.navigation.rememberListDetailPaneScaffoldNavigator
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.colorResource
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.lifecycle.lifecycleScope
import androidx.work.WorkManager
import kotlinx.coroutines.launch
import uk.co.amlcurran.social.details.EventDetailActivity
import uk.co.amlcurran.social.details.EventDetails
import uk.co.amlcurran.social.widget.NextWeekWidget
import uk.co.amlcurran.social.widget.WidgetUpdateWorker
import uk.co.amlcurran.starlinginterview.AsyncContent

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

    @OptIn(ExperimentalMaterial3AdaptiveApi::class)
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
                val scaffoldNavigator = rememberListDetailPaneScaffoldNavigator<String>()
                val scope = rememberCoroutineScope()
                val context = LocalContext.current

                NavigableListDetailPaneScaffold(
                    navigator = scaffoldNavigator,
                    listPane = {
                        AnimatedPane {
                            MainList(viewModel, { event ->
                                scope.launch {
                                    scaffoldNavigator.navigateTo(
                                        ListDetailPaneScaffoldRole.Detail,
                                        event.eventId
                                    )
                                }
                            }, ::emptySelected)
                        }
                    },
                    detailPane = {
                        AnimatedPane {
                            // Show the detail pane content if selected item is available
                            scaffoldNavigator.currentDestination?.contentKey?.let { eventId ->
                                EventDetails(eventId) {
                                    scope.launch {
                                        scaffoldNavigator.navigateBack()
                                    }
                                }
                            }
                        }
                    },
                )
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

@Composable
private fun MainList(
    viewModel: EventListViewModel,
    eventSelected: (EventCalendarItem) -> Unit,
    emptySelected: (CalendarSlot) -> Unit
) {
    val context = LocalContext.current
    Scaffold(
        topBar = {
            Row(modifier = Modifier.statusBarsPadding()) {
                HeaderView(modifier = Modifier.weight(1f))
                IconButton(
                    onClick = { SettingsActivity.start(context as Activity) },
                    colors = IconButtonDefaults.iconButtonColors(
                        contentColor = MaterialTheme.colorScheme.onBackground
                    )
                ) {
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
            SlotsView(calendarSource.slots, eventSelected, emptySelected)
        }
    }
}
