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
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.updatePadding
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
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
    private val eventsRepository: AndroidEventsRepository by lazy { AndroidEventsRepository(contentResolver) }
    private val eventsService: EventsService by lazy { EventsService(eventsRepository, JodaCalculator(), UserSettings(this)) }
    private lateinit var binding: ActivityWhatsOnBinding

    private val permissionRequest = registerForActivityResult(RequestMultiplePermissions()) { permissions ->
        if (permissions.all { (_, granted) -> granted }) {
            binding.progressBar.alphaIn()
            val now = DateTime.now(DateTimeZone.getDefault())
            val timestamp = Timestamp(now.millis)
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
            val day = DateTime(0, DateTimeZone.getDefault()).plusDays(calendarItem.startTime.daysSinceEpoch(JodaCalculator()))
            val startTime = day.plusHours(18)
            val endTime = day.plusHours(22)
            intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.millis)
            intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.millis)
            if (false) {
                startActivity(Intent(this@WhatsOnActivity, AddEventActivity::class.java))
            } else {
                startActivity(intent)
            }
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityWhatsOnBinding.inflate(LayoutInflater.from(this))
        binding.toolbarCompose.setContent {
            HeaderView()
        }
        setContentView(binding.root)

        binding.toolbar.setOnMenuItemClickListener { item ->
            when (item.itemId) {
                R.id.pick_times -> {
                    SettingsActivity.start(this)
                    true
                }
                else -> false
            }
        }

        val calendarSource = CalendarSource(HashMap(), 0, JodaCalculator(), UserSettings(this))
        adapter = WhatsOnAdapter(LayoutInflater.from(this), eventSelectedListener, calendarSource)
        binding.listWhatsOn.layoutManager = LinearLayoutManager(this)
        binding.listWhatsOn.adapter = adapter

        ViewCompat.setOnApplyWindowInsetsListener(binding.toolbar) { _, insets ->
            binding.toolbar.updatePadding(top = insets.getInsets(WindowInsetsCompat.Type.systemBars()).bottom)
            insets
        }

        ViewCompat.setOnApplyWindowInsetsListener(binding.listWhatsOn) { _, insets ->
            binding.listWhatsOn.updatePadding(bottom = insets.getInsets(WindowInsetsCompat.Type.systemBars()).bottom)
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
