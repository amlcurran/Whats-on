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
import uk.co.amlcurran.social.R

private const val KEY_EVENT_ID = "event_id"

class EventDetailActivity: AppCompatActivity() {

    private lateinit var eventId: String

    companion object {

        fun show(eventId: String, context: Context): Intent {
            val intent = Intent(context, EventDetailActivity::class.java)
            intent.putExtra(KEY_EVENT_ID, eventId)
            return intent
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_event_details)
        eventId = intent.getStringExtra(KEY_EVENT_ID) ?: throw IllegalStateException("missing event ID")

        setSupportActionBar(toolbar2)
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