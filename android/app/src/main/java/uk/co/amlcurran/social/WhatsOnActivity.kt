package uk.co.amlcurran.social

import android.Manifest
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.view.LayoutInflater
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts.RequestMultiplePermissions
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.updatePadding
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.rxkotlin.subscribeBy
import io.reactivex.schedulers.Schedulers
import kotlinx.coroutines.launch
import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import org.joda.time.format.DateTimeFormat
import uk.co.amlcurran.social.add.AddEventActivity
import uk.co.amlcurran.social.databinding.ActivityWhatsOnBinding
import uk.co.amlcurran.social.details.EventDetailActivity
import uk.co.amlcurran.social.details.alphaIn
import uk.co.amlcurran.social.details.alphaOut

class WhatsOnActivity : AppCompatActivity() {
    private lateinit var adapter: WhatsOnAdapter
    private var firstLoad = true
    private val eventsRepository = AndroidEventsRepository(contentResolver, CalendarRepository(this))
    private val dateCreator = AndroidTimeRepository(this)
    private val eventsService = EventsService(dateCreator, eventsRepository, JodaCalculator())
    private lateinit var binding: ActivityWhatsOnBinding

    private val permissionRequest = registerForActivityResult(RequestMultiplePermissions()) { permissions ->
        if (permissions.all { (_, granted) -> granted }) {
            binding.progressBar.alphaIn()
            val now = DateTime.now(DateTimeZone.getDefault())
            val timestamp = Timestamp(now.millis, JodaCalculator())
            lifecycleScope.launch {
                try {
                    val it = eventsService.getCalendarSource(14, timestamp)
                    firstLoad = false
                    adapter.onSuccess(it)
                    binding.progressBar.alphaOut()
                    binding.listWhatsOn.alphaIn()
                } catch (e: Throwable) {
                    firstLoad = false
                    binding.progressBar.alphaOut()
                    adapter.onError(e)

                }

            }
        }
    }

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
            if (true) {
                startActivity(Intent(this@WhatsOnActivity, AddEventActivity::class.java))
            } else {
                startActivity(intent)
            }
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
        if (resources.getBoolean(R.bool.isLightBackgroundStatusBar)) {
            window.decorView.systemUiVisibility += View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
        }

        setContentView(R.layout.activity_whats_on)

        binding.toolbar.setOnMenuItemClickListener { item ->
            when (item.itemId) {
                R.id.pick_times -> {
                    SettingsActivity.start(this)
                    true
                }
                else -> false
            }
        }

        val now = DateTime.now(DateTimeZone.getDefault())

        val calendarSource = CalendarSource(HashMap(), 0, JodaCalculator(), AndroidTimeRepository(this))
        adapter = WhatsOnAdapter(LayoutInflater.from(this), eventSelectedListener, calendarSource)
        binding.listWhatsOn.layoutManager = LinearLayoutManager(this)
        binding.listWhatsOn.adapter = adapter

        binding.todayDate.text = DateTimeFormat.forPattern("EEEE, dd MMMMM").print(now)

        ViewCompat.setOnApplyWindowInsetsListener(binding.toolbar) { _, insets ->
            binding.toolbar.updatePadding(top = insets.systemWindowInsetTop)
            insets
        }

        ViewCompat.setOnApplyWindowInsetsListener(binding.listWhatsOn) { _, insets ->
            binding.listWhatsOn.updatePadding(bottom = insets.systemWindowInsetBottom)
            insets
        }
    }

    override fun onResume() {
        super.onResume()
        reload()
    }

    private fun reload() {
        permissionRequest.launch(arrayOf(Manifest.permission.READ_CALENDAR, Manifest.permission.WRITE_CALENDAR))
    }

}
