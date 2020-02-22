package uk.co.amlcurran.social.details

import android.app.Dialog
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.location.Geocoder
import android.net.Uri
import android.os.Bundle
import android.provider.CalendarContract
import android.util.Log
import android.view.MenuItem
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.DialogFragment
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import io.reactivex.Maybe
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.rxkotlin.plusAssign
import io.reactivex.rxkotlin.subscribeBy
import io.reactivex.schedulers.Schedulers
import kotlinx.android.synthetic.main.activity_event_details.*
import kotlinx.android.synthetic.main.item_event.*
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import uk.co.amlcurran.social.*

class EventDetailActivity : AppCompatActivity() {

    private lateinit var eventId: String
    private val subscriptions = CompositeDisposable()
    private val timeFormatter: DateTimeFormatter by lazy { DateTimeFormat.shortTime() }
    private val jodaCalculator = JodaCalculator()
    private val events: Events by lazy {
        val calendarRepository = CalendarRepository(this)
        val eventsRepository = AndroidEventsRepository(contentResolver, calendarRepository)
        Events(eventsService = EventsService(AndroidTimeRepository(this), eventsRepository, jodaCalculator))
    }

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
        setContentView(R.layout.activity_event_details)
        eventId = intent.getStringExtra(KEY_EVENT_ID)
            ?: throw IllegalStateException("missing event ID")

        subscriptions += events.loadSingleEvent(eventId)
            .subscribeBy(
                onSuccess = ::render,
                onError = {
                    it.printStackTrace()
                    Snackbar.make(event_card, R.string.something_went_wrong, Snackbar.LENGTH_LONG).show()
                }
            )

        detail_toolbar.setOnMenuItemClickListener(::onOptionsItemSelected)
        detail_toolbar.setNavigationOnClickListener { finish() }
    }

    private fun render(event: Event) {
        event_title.text = event.item.title
        val startTime = event.item.startTime.format(timeFormatter, jodaCalculator)
        val endTime = event.item.endTime.format(timeFormatter, jodaCalculator)
        event_subtitle.text = getString(R.string.start_to_end, startTime, endTime)
        detail_toolbar.menu.findItem(R.id.menu_open_outside).isVisible = true
        detail_toolbar.menu.findItem(R.id.menu_delete_event).isVisible = true
        updateMap(event.location)
    }

    private fun updateMap(location: String?) {
        location?.let {
            subscriptions += findLocation(location)
                .subscribeBy(onSuccess = ::show, onError = ::doNothing)
        }
    }

    private fun doNothing(throwable: Throwable) {
        Log.w("Failure", throwable)
    }

    private fun show(latLng: LatLng) {
        val mapFragment = SupportMapFragment.newInstance()
        supportFragmentManager.beginTransaction()
            .add(R.id.mapHost, mapFragment)
            .commit()
        mapHost.alpha = 0f
        mapFragment.getMapAsync { map ->
            map.uiSettings.setAllGesturesEnabled(false)
            mapHost.alphaIn(translate = true)
            map.addMarker(MarkerOptions().position(latLng))
            map.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 15f))
            mapHost.setOnClickListener {
                startActivity(Intent(Intent.ACTION_VIEW).apply {
                    data = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=${latLng.latitude},${latLng.longitude}")
                })
            }
        }
    }

    private fun findLocation(location: String): Maybe<LatLng> {
        return Maybe.fromCallable { Geocoder(this).getFromLocationName(location, 10).firstOrNull() }
            .map { LatLng(it.latitude, it.longitude) }
            .subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread())
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.menu_open_outside -> launchInExternalCalendar()
            R.id.menu_delete_event -> confirmDelete()
        }
        return true
    }

    private fun confirmDelete() {
        ConfirmDelete().apply {
            onConfirm = { deleteEvent() }
            show(supportFragmentManager, null)
        }

    }

    private fun deleteEvent() {
        subscriptions += events.delete(eventId)
            .subscribeBy(
                onComplete = { finish() },
                onError = { Snackbar.make(event_card, getString(R.string.couldnt_delete_event), Snackbar.LENGTH_SHORT).show() }
            )
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

fun Timestamp.format(dateTimeFormatter: DateTimeFormatter, calculator: JodaCalculator) = dateTimeFormatter.print(calculator.getDateTime(this))
