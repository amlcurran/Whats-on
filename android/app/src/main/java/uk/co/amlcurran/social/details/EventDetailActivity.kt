package uk.co.amlcurran.social.details

import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.view.LayoutInflater
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ArrowBack
import androidx.compose.material.icons.rounded.Delete
import androidx.compose.material.icons.rounded.ExitToApp
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.zIndex
import androidx.lifecycle.compose.LifecycleStartEffect
import kotlinx.coroutines.launch
import kotlinx.datetime.Instant
import uk.co.amlcurran.social.AndroidEventsRepository
import uk.co.amlcurran.social.Event
import uk.co.amlcurran.social.EventCalendarItem
import uk.co.amlcurran.social.EventPredicates
import uk.co.amlcurran.social.EventsService
import uk.co.amlcurran.social.JodaCalculator
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.UserSettings
import uk.co.amlcurran.social.databinding.ActivityEventDetailsBinding

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EventDetails(eventId: String, onNavigateBack: () -> Unit) {
    val (event, setEvent) = remember { mutableStateOf<Event?>(null) }
    val (showDialog, setShowDialog) = remember { mutableStateOf(false) }
    val context = LocalContext.current
    val coroutineScope = rememberCoroutineScope()
    val snackbar = remember { SnackbarHostState() }
    val eventsRepository = remember {
        val calendarRepository = UserSettings(context)
        val eventsRepository = AndroidEventsRepository(context.contentResolver)
        val predicate = EventPredicates(UserSettings(context.applicationContext)).defaultPredicate
        EventsService(eventsRepository, JodaCalculator(), calendarRepository, predicate)
    }
    LifecycleStartEffect(eventId) {
        try {
            val loadedEvent = eventsRepository.eventWithId(eventId)!!
            setEvent(loadedEvent)
        } catch (e: Error) {
            e.printStackTrace()
            coroutineScope.launch {
                snackbar.showSnackbar("Something went wrong")
            }
        }
        onStopOrDispose {

        }
    }
    Scaffold(
        snackbarHost = { SnackbarHost(snackbar) },
        topBar = {
            TopAppBar(
                title = { },
                navigationIcon = {
                    IconButton(onNavigateBack) {
                        Icon(Icons.AutoMirrored.Rounded.ArrowBack, "Back")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = colorResource(id = R.color.background)
                ),
            )
        },
        bottomBar = {
            BottomAppBar {
                IconButton({
                    val id = eventId.toLong()
                    val eventUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, id)
                    context.startActivity(Intent(Intent.ACTION_VIEW).setData(eventUri))
                }) {
                    Icon(Icons.Rounded.ExitToApp, "Open in calendar")
                }
                IconButton({ setShowDialog(true) }) {
                    Icon(Icons.Rounded.Delete, "Delete")
                }
            }
        }
    ) {
        if (showDialog) {
            AlertDialog(
                onDismissRequest = { setShowDialog(false) },
                confirmButton = { TextButton({
                    eventsRepository.delete(eventId)
                    onNavigateBack()
                }) { Text("Confirm") } },
                text = { Text(text = stringResource(R.string.confirm_delete_message)) }
            )
        }
        if (event != null) {
            EventCardLoaded(modifier = Modifier.padding(it), event)
        }
    }
}

@Composable
private fun EventCardLoaded(modifier: Modifier = Modifier, event: Event) {
    Column(Modifier.padding(horizontal = 16.dp)) {
        EventCard(modifier.fillMaxWidth(), event)
        EventMap(Modifier
            .offset(y = (-32).dp)
            .zIndex(-1f), event
        )
    }
}

class EventDetailActivity : AppCompatActivity() {

    private lateinit var eventId: String
    private lateinit var binding: ActivityEventDetailsBinding

    companion object {

        private const val KEY_EVENT_TITLE = "title"
        const val KEY_EVENT_ID = "event_id"

        fun show(event: EventCalendarItem, context: Context): Intent {
            val intent = Intent(context, EventDetailActivity::class.java)
            intent.putExtra(KEY_EVENT_ID, event.eventId)
            intent.putExtra(KEY_EVENT_TITLE, event.title)
            return intent
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityEventDetailsBinding.inflate(LayoutInflater.from(this))
        setContentView(binding.root)

        eventId = intent.getStringExtra(KEY_EVENT_ID)
            ?: throw IllegalStateException("missing event ID")

        render(eventId)
    }

    private fun render(event: String) {
        binding.eventCard2.setContent {
            EventDetails(event) {
                finish()
            }
        }
    }

}

@Composable
@Preview(showBackground = true)
fun EventDetailPreview() {
    EventCardLoaded(event = Event(
        EventCalendarItem(
            "abc",
            "calendar",
            "A fun event",
            Instant.fromEpochMilliseconds(System.currentTimeMillis()),
            Instant.fromEpochMilliseconds(System.currentTimeMillis() - 60 * 60 * 1000 * 2),
            emptyList()
        ), "Kings Cross St. Pancras"
    ))
}

fun View.alphaIn(translate: Boolean = false) {
    alpha = 0f
    visibility = View.VISIBLE
    if (translate) {
        translationY = -context.resources.getDimension(R.dimen.slide_in_length)
    }
    animate()
        .alpha(1f)
        .translationY(0f)
        .setDuration(context.resources.getInteger(android.R.integer.config_shortAnimTime).toLong())
        .start()
}

fun View.alphaOut() {
    alpha = 1f
    animate()
        .alpha(0f)
        .setDuration(300)
        .withEndAction { visibility = View.GONE }
        .start()
}
