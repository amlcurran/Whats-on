package uk.co.amlcurran.social

import android.Manifest
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.updatePadding
import androidx.recyclerview.widget.LinearLayoutManager
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.rxkotlin.subscribeBy
import io.reactivex.schedulers.Schedulers
import kotlinx.android.synthetic.main.activity_whats_on.*
import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import org.joda.time.format.DateTimeFormat
import uk.co.amlcurran.social.details.EventDetailActivity
import uk.co.amlcurran.social.details.alphaIn
import uk.co.amlcurran.social.details.alphaOut

class WhatsOnActivity : AppCompatActivity() {
    private lateinit var permissions: Permissions
    private lateinit var adapter: WhatsOnAdapter
    private lateinit var events: Events
    private var loadDisposable: Disposable? = null
    private var firstLoad = true

    private val eventSelectedListener = object : WhatsOnAdapter.EventSelectedListener {
        override fun eventSelected(calendarItem: EventCalendarItem, itemView: View) {
            startActivity(EventDetailActivity.show(calendarItem, this@WhatsOnActivity))
        }

        override fun emptySelected(calendarItem: EmptyCalendarItem) {
            val intent = Intent(Intent.ACTION_INSERT)
            intent.data = CalendarContract.Events.CONTENT_URI
            val day = DateTime(0, DateTimeZone.getDefault()).plusDays(calendarItem.startTime.daysSinceEpoch())
            val startTime = day.plusHours(18)
            val endTime = day.plusHours(22)
            intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.millis)
            intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.millis)
            startActivity(intent)
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
        if (resources.getBoolean(R.bool.isLightBackgroundStatusBar)) {
            window.decorView.systemUiVisibility += View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
        }

        setContentView(R.layout.activity_whats_on)
        permissions = Permissions(this)
        val eventsRepository = AndroidEventsRepository(contentResolver, CalendarRepository(this))
        val dateCreator = AndroidTimeRepository(this)
        val mainThread = AndroidSchedulers.mainThread()
        val background = Schedulers.io()
        events = Events(mainThread, background, EventsService(dateCreator, eventsRepository, JodaCalculator()))

        toolbar.setOnMenuItemClickListener { onOptionsItemSelected(it) }

        val now = DateTime.now(DateTimeZone.getDefault())

        val calendarSource = CalendarSource(HashMap(), 0, JodaCalculator(), AndroidTimeRepository(this))
        adapter = WhatsOnAdapter(LayoutInflater.from(this), eventSelectedListener, calendarSource)
        list_whats_on.layoutManager = LinearLayoutManager(this)
        list_whats_on.adapter = adapter

        today_date.text = DateTimeFormat.forPattern("EEEE, dd MMMMM").print(now)

        ViewCompat.setOnApplyWindowInsetsListener(toolbar) { _, insets ->
            toolbar.updatePadding(top = insets.systemWindowInsetTop)
            insets
        }

        ViewCompat.setOnApplyWindowInsetsListener(list_whats_on) { _, insets ->
            list_whats_on.updatePadding(bottom = insets.systemWindowInsetBottom)
            insets
        }
    }

    override fun onResume() {
        super.onResume()
        reload()
    }

    private fun reload() {
        val now = DateTime.now(DateTimeZone.getDefault())
        permissions.requestPermission(REQUEST_CODE_REQUEST_CALENDAR, object : Permissions.OnPermissionRequestListener {
            override fun onPermissionGranted() {
                progressBar.alphaIn()
                val timestamp = Timestamp(now.millis, JodaCalculator())
                loadDisposable = events.load(timestamp, if (firstLoad) 1000 else 0)
                        .subscribeBy(
                                onSuccess = {
                                    firstLoad = false
                                    adapter.onSuccess(it)
                                    progressBar.alphaOut()
                                    list_whats_on.alphaIn()
                                },
                                onError = {
                                    firstLoad = false
                                    progressBar.alphaOut()
                                    adapter.onError(it)
                                }
                        )
            }

            override fun onPermissionDenied() {

            }
        }, Manifest.permission.READ_CALENDAR, Manifest.permission.WRITE_CALENDAR)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {

            R.id.pick_times -> {
                SettingsActivity.start(this)
                return true
            }
        }
        return super.onOptionsItemSelected(item)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        this.permissions.onRequestPermissionResult(requestCode, grantResults)
    }

    companion object {

        private const val REQUEST_CODE_REQUEST_CALENDAR = 1
    }

}
