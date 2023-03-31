package uk.co.amlcurran.social

import android.Manifest
import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.view.LayoutInflater
import androidx.activity.result.contract.ActivityResultContracts.RequestMultiplePermissions
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.MaterialTheme
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.colorResource
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import uk.co.amlcurran.social.add.AddEventActivity
import uk.co.amlcurran.social.databinding.ActivityWhatsOnBinding
import uk.co.amlcurran.social.details.EventDetailActivity
import uk.co.amlcurran.starlinginterview.AsyncContent

class WhatsOnActivity : AppCompatActivity() {
    private lateinit var binding: ActivityWhatsOnBinding
    private val viewModel: EventListViewModel by viewModels()

    private val permissionRequest =
        registerForActivityResult(RequestMultiplePermissions()) { permissions ->
            if (permissions.all { (_, granted) -> granted }) {
                lifecycleScope.launch {
                    viewModel.load()
                }
            }
        }

        private fun eventSelected(calendarItem: EventCalendarItem) {
            startActivity(EventDetailActivity.show(calendarItem, this@WhatsOnActivity))
        }

        private fun emptySelected(calendarItem: CalendarSlot) {
            val intent = Intent(Intent.ACTION_INSERT)
            intent.data = CalendarContract.Events.CONTENT_URI
            intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, calendarItem.startTimestamp.millis)
            intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, calendarItem.endTimestamp.millis)
            if (false) {
                startActivity(Intent(this@WhatsOnActivity, AddEventActivity::class.java))
            } else {
                startActivity(intent)
            }
        }

    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityWhatsOnBinding.inflate(LayoutInflater.from(this))
        binding.eventListCompose.setContent {
            WhatsOnTheme {
                Scaffold(
                    topBar = {
                        Row {
                            HeaderView(modifier = Modifier.weight(1f))
                            IconButton(onClick = { SettingsActivity.start(this@WhatsOnActivity) },
                            colors = IconButtonDefaults.iconButtonColors(
                                contentColor = MaterialTheme.colors.onBackground
                            )) {
                                Icon(Icons.Outlined.Settings, contentDescription = "Settings")
                            }
                        }
                    },
                    containerColor = colorResource(id = R.color.background)
                ) { padding ->
                    val subscriptionsState = viewModel.source.collectAsState()
                    AsyncContent(
                        state = subscriptionsState.value,
                        modifier = Modifier
                            .padding(padding)
                            .background(colorResource(id = R.color.background))
                    ) { calendarSource ->
                        SlotsView(calendarSource.allSlots(), ::eventSelected, ::emptySelected)
                    }
                }
            }
        }
        setContentView(binding.root)


//        adapter = WhatsOnAdapter(LayoutInflater.from(this), eventSelectedListener, calendarSource)
//        binding.listWhatsOn.layoutManager = LinearLayoutManager(this)
//        binding.listWhatsOn.adapter = adapter
//
//        ViewCompat.setOnApplyWindowInsetsListener(binding.toolbar) { _, insets ->
//            binding.toolbar.updatePadding(top = insets.getInsets(WindowInsetsCompat.Type.systemBars()).bottom)
//            insets
//        }
//
//        ViewCompat.setOnApplyWindowInsetsListener(binding.listWhatsOn) { _, insets ->
//            binding.listWhatsOn.updatePadding(bottom = insets.getInsets(WindowInsetsCompat.Type.systemBars()).bottom)
//            insets
//        }
    }


    override fun onResume() {
        super.onResume()
        reload()
    }

    private fun reload() {
        permissionRequest.launch(
            arrayOf(
                Manifest.permission.READ_CALENDAR,
                Manifest.permission.WRITE_CALENDAR
            )
        )
    }

}
