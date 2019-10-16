package uk.co.amlcurran.social.details

import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.get
import com.google.android.material.snackbar.Snackbar
import io.reactivex.disposables.Disposable
import io.reactivex.rxkotlin.subscribeBy
import kotlinx.android.synthetic.main.activity_event_details.*
import kotlinx.android.synthetic.main.item_event.*
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import uk.co.amlcurran.social.*

class EventDetailActivity: AppCompatActivity() {

    private lateinit var eventId: String
    private var subscription: Disposable? = null
    private val timeFormatter: DateTimeFormatter by lazy { DateTimeFormat.shortTime() }
    private val jodaCalculator = JodaCalculator()
    private val events: Events by lazy { Events(eventsService = EventsService(AndroidTimeRepository(), AndroidEventsRepository(contentResolver), jodaCalculator)) }

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
        eventId = intent.getStringExtra(KEY_EVENT_ID) ?: throw IllegalStateException("missing event ID")

        subscription = events.loadSingleEvent(eventId)
                .subscribeBy(
                        onSuccess = ::render,
                        onError = {
                            it.printStackTrace()
                            Snackbar.make(event_card, R.string.something_went_wrong, Snackbar.LENGTH_LONG).show()
                        }
                )

        toolbar2.setOnMenuItemClickListener { item ->
            when (item.itemId) {
                R.id.menu_open_outside -> launchInExternalCalendar()
            }
            true
        }
        toolbar2.setNavigationOnClickListener { finish() }
    }

    private fun render(event: Event) {
        event_title.text = event.item.title
        val startTime = event.item.startTime.format(timeFormatter, jodaCalculator)
        val endTime = event.item.endTime.format(timeFormatter, jodaCalculator)
        event_subtitle.text = getString(R.string.start_to_end, startTime, endTime)
        toolbar2.menu.findItem(R.id.menu_open_outside).isVisible = true
        Log.d("foo", event.location)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.menu_open_outside -> launchInExternalCalendar()
        }
        return true
    }

    private fun launchInExternalCalendar() {
        val id = eventId.toLong()
        val eventUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, id)
        startActivity(Intent(Intent.ACTION_VIEW).setData(eventUri))
    }

}

fun Timestamp.format(dateTimeFormatter: DateTimeFormatter, calculator: JodaCalculator) = dateTimeFormatter.print(calculator.getDateTime(this))
