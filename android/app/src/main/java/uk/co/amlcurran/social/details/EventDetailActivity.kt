package uk.co.amlcurran.social.details

import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_event_details.*
import rx.Single
import rx.Subscription
import rx.android.schedulers.AndroidSchedulers
import rx.schedulers.Schedulers
import rx.subscriptions.Subscriptions
import uk.co.amlcurran.social.*

class EventDetailActivity: AppCompatActivity() {

    private lateinit var eventId: String
    private var subscription: Subscription? = null

    companion object {

        private const val KEY_EVENT_TITLE: String = "title"
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
                .subscribe(
                        { event -> },
                        { error -> }
                )

        toolbar2.setNavigationOnClickListener {
            finish()
        }
        setSupportActionBar(toolbar2)
    }

    private fun loadEvent(eventId: String): Single<Event> {
        return Single.create {
            val cursor = contentResolver.query(ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId.toLong()),
                    AndroidEventsRepository.PROJECTION, null, null, null)
            val accessor = CursorEventRepositoryAccessor(cursor!!, JodaCalculator())
            if (accessor.nextItem()) {
                val title = accessor.title
                val time = accessor.startTime
                val endTime = accessor.endTime
                val item = EventCalendarItem(eventId, title, time, endTime)
                it.onSuccess(Event(item))
            } else {
                it.onError(NoSuchElementException())
            }
            Subscriptions.create {
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

data class Event(private  val item: EventCalendarItem) {

}
