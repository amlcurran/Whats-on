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
import com.google.android.material.snackbar.Snackbar
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.disposables.Disposables
import io.reactivex.rxkotlin.subscribeBy
import io.reactivex.schedulers.Schedulers
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

        subscription = loadEvent(eventId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeBy(
                        onSuccess = { event ->
                            event_title.text = event.item.title
                            val startTime = timeFormatter.print(jodaCalculator.getDateTime(event.item.startTime))
                            val endTime = timeFormatter.print(jodaCalculator.getDateTime(event.item.endTime))
                            event_subtitle.text = getString(R.string.start_to_end, startTime, endTime)
                            Log.d("foo", event.location)
                        },
                        onError = { Snackbar.make(event_card, R.string.something_went_wrong, Snackbar.LENGTH_LONG).show() }
                )

        toolbar2.setNavigationOnClickListener {
            finish()
        }
        setSupportActionBar(toolbar2)
    }

    private fun loadEvent(eventId: String): Single<Event> {
        return Single.create {
            val cursor = contentResolver.query(ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId.toLong()),
                    AndroidEventsRepository.SINGLE_PROJECTION, null, null, null)
            val accessor = CursorEventRepositoryAccessor(cursor!!, JodaCalculator())
            if (accessor.nextItem()) {
                val title = accessor.title
                val time = accessor.startTime
                val endTime = accessor.endTime
                val item = EventCalendarItem(eventId, title, time, endTime)
                it.onSuccess(Event(item, accessor.getString(CalendarContract.Events.EVENT_LOCATION)))
            } else {
                it.onError(NoSuchElementException())
            }
            Disposables.fromAction {
                cursor.close()
            }
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.activity_details, menu)
        return super.onCreateOptionsMenu(menu)
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

data class Event(val item: EventCalendarItem, val location: String)
