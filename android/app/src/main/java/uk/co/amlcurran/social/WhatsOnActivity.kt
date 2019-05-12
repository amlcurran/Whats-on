package uk.co.amlcurran.social

import android.Manifest
import android.content.ContentUris
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuItem
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import org.joda.time.format.DateTimeFormat
import rx.android.schedulers.AndroidSchedulers
import rx.schedulers.Schedulers
import uk.co.amlcurran.social.core.SparseArray

class WhatsOnActivity : AppCompatActivity() {
    private lateinit var permissions: Permissions
    private lateinit var adapter: WhatsOnAdapter
    private lateinit var events: Events

    private val eventSelectedListener = object : WhatsOnAdapter.EventSelectedListener {
        override fun eventSelected(calendarItem: EventCalendarItem) {
            val id = java.lang.Long.valueOf(calendarItem.id())
            val eventUri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, id)
            startActivity(Intent(Intent.ACTION_VIEW).setData(eventUri))
        }

        override fun emptySelected(calendarItem: EmptyCalendarItem) {
            val intent = Intent(Intent.ACTION_INSERT)
            intent.data = CalendarContract.Events.CONTENT_URI
            val day = DateTime(0, DateTimeZone.getDefault()).plusDays(calendarItem.startTime().daysSinceEpoch())
            val startTime = day.plusHours(17)
            val endTime = day.plusHours(22)
            intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.millis)
            intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.millis)
            startActivity(intent)
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_whats_on)
        permissions = Permissions(this)
        val eventsRepository = AndroidEventsRepository(contentResolver)
        val dateCreator = AndroidTimeRepository()
        val mainThread = AndroidSchedulers.mainThread()
        val background = Schedulers.io()
        events = Events(mainThread, background, EventsService(dateCreator, eventsRepository, JodaCalculator()))

        val now = DateTime.now(DateTimeZone.getDefault())

        val recyclerView = findViewById<RecyclerView>(R.id.list_whats_on)
        val calendarSource = CalendarSource(SparseArray(), 0, JodaCalculator(), AndroidTimeRepository())
        adapter = WhatsOnAdapter(LayoutInflater.from(this), eventSelectedListener, calendarSource)
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = adapter

        val today = findViewById<TextView>(R.id.today_date)
        today.text = DateTimeFormat.forPattern("EEEE, dd MMMMM").print(now)

        permissions.requestPermission(REQUEST_CODE_REQUEST_CALENDAR, Manifest.permission.READ_CALENDAR, object : Permissions.OnPermissionRequestListener {
            override fun onPermissionGranted() {
                events.load(Timestamp(now.millis, JodaCalculator()), adapter)
            }

            override fun onPermissionDenied() {

            }
        })
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.activity_whats_on, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {

            R.id.pick_times -> {
                TimePickerActivity.start(this)
                return true
            }
        }
        return super.onOptionsItemSelected(item)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        this.permissions.onRequestPermissionResult(requestCode, permissions, grantResults)
    }

    companion object {

        private const val REQUEST_CODE_REQUEST_CALENDAR = 1
    }

}
