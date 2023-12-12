package uk.co.amlcurran.social.details

import android.app.Dialog
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.location.Geocoder
import android.net.Uri
import android.os.Bundle
import android.provider.CalendarContract
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.lifecycleScope
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import com.google.maps.android.compose.CameraPositionState
import com.google.maps.android.compose.GoogleMap
import com.google.maps.android.compose.MapUiSettings
import com.google.maps.android.compose.Marker
import com.google.maps.android.compose.MarkerState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import uk.co.amlcurran.social.AndroidEventsRepository
import uk.co.amlcurran.social.Event
import uk.co.amlcurran.social.EventCalendarItem
import uk.co.amlcurran.social.EventPredicates
import uk.co.amlcurran.social.EventsService
import uk.co.amlcurran.social.JodaCalculator
import uk.co.amlcurran.social.R
import uk.co.amlcurran.social.UserSettings
import uk.co.amlcurran.social.databinding.ActivityEventDetailsBinding
import kotlin.coroutines.suspendCoroutine

class EventDetailActivity : AppCompatActivity() {

    private lateinit var eventId: String
    private val jodaCalculator = JodaCalculator()
    private val events by lazy {
        val calendarRepository = UserSettings(this)
        val eventsRepository = AndroidEventsRepository(contentResolver)
        val predicate = EventPredicates(UserSettings(application)).defaultPredicate
        EventsService(eventsRepository, jodaCalculator, calendarRepository, predicate)
    }
    private lateinit var binding: ActivityEventDetailsBinding

    companion object {

        private const val KEY_EVENT_TITLE = "title"
        private const val KEY_EVENT_ID = "event_id"

        fun show(event: EventCalendarItem, context: Context): Intent {
            val intent = Intent(context, EventDetailActivity::class.java)
            intent.putExtra(KEY_EVENT_ID, event.id())
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

        lifecycleScope.launchWhenCreated {
            try {
                val event = events.eventWithId(eventId)!!
                render(event)
            } catch (e: Error) {
                e.printStackTrace()
                Snackbar.make(binding.root, R.string.something_went_wrong, Snackbar.LENGTH_LONG)
                    .show()
            }
        }

        binding.detailToolbar.setOnMenuItemClickListener(::onOptionsItemSelected)
        binding.detailToolbar.setNavigationOnClickListener { finish() }
    }

    private fun render(event: Event) {
        binding.eventCard2.setContent {
            EventCard(event = event)
        }
        binding.detailToolbar.menu.findItem(R.id.menu_open_outside).isVisible = true
        binding.detailToolbar.menu.findItem(R.id.menu_delete_event).isVisible = true
        binding.detailToolbar.menu.findItem(R.id.menu_hide_event).isVisible = true
        updateMap(event.location)
    }

    private fun updateMap(location: String?) {
        location?.let {
            lifecycleScope.launch(Dispatchers.IO) {
                if (it.isNotBlank()) {
                    findLocation(it)?.let { show(it) }
                }
            }
        }
    }

    private fun show(latLng: LatLng) {
        binding.mapHost.setContent {
            GoogleMap(
                modifier = Modifier.clip(
                    RoundedCornerShape(
                        topStart = 0.dp,
                        topEnd = 0.dp,
                        bottomStart = 8.dp,
                        bottomEnd = 8.dp
                    )
                ),
                onMapClick = {
                    startActivity(Intent(Intent.ACTION_VIEW).apply {
                        data =
                            Uri.parse("https://www.google.com/maps/dir/?api=1&destination=${latLng.latitude},${latLng.longitude}")
                    })
                },
                uiSettings = MapUiSettings(
                    zoomControlsEnabled = false,
                    rotationGesturesEnabled = false,
                    scrollGesturesEnabled = false,
                    tiltGesturesEnabled = false,
                    zoomGesturesEnabled = false
                ),
                cameraPositionState = CameraPositionState(
                    CameraPosition.fromLatLngZoom(
                        latLng,
                        15f
                    )
                )
            ) {
                Marker(state = MarkerState(position = latLng))
            }
        }
    }

    private suspend fun findLocation(location: String): LatLng? {
        return suspendCoroutine { continuation ->
            try {
                val result = Geocoder(this).getFromLocationName(location, 10)?.firstOrNull()
                val latLng = result?.let { LatLng(it.latitude, it.longitude) }
                continuation.resumeWith(Result.success(latLng))
            } catch (e: Throwable) {
                continuation.resumeWith(Result.failure(e))
            }
        }
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.menu_open_outside -> launchInExternalCalendar()
            R.id.menu_delete_event -> confirmDelete()
            R.id.menu_hide_event -> hideEvent()
        }
        return true
    }

    private fun hideEvent() {
        val calendarRepository = UserSettings(this)
        calendarRepository.hide(eventId)
        finish()
    }

    private fun confirmDelete() {
        ConfirmDelete().apply {
            onConfirm = { deleteEvent() }
            show(supportFragmentManager, null)
        }

    }

    private fun deleteEvent() {
        lifecycleScope.launch {
            events.delete(eventId)
            finish()
        }
    }

    private fun launchInExternalCalendar() {
        val id = eventId.toLong()
        val eventUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, id)
        startActivity(Intent(Intent.ACTION_VIEW).setData(eventUri))
    }

}

class ConfirmDelete : DialogFragment() {

    lateinit var onConfirm: () -> Unit

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        return MaterialAlertDialogBuilder(requireContext())
            .setMessage(R.string.confirm_delete_message)
            .setPositiveButton(R.string.delete) { _, _ -> onConfirm() }
            .setNegativeButton(R.string.cancel) { dialog, _ -> dialog.dismiss() }
            .create()
    }
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
