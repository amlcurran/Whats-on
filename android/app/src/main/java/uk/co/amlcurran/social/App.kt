package uk.co.amlcurran.social

import android.app.Application
import android.content.Intent
import android.provider.CalendarContract
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import org.joda.time.DateTime

class App: Application() {

    override fun onCreate() {
        super.onCreate()
        ShortcutManagerCompat.addDynamicShortcuts(this, listOf(addEventToday()))
    }

    private fun addEventToday(): ShortcutInfoCompat {
        return ShortcutInfoCompat.Builder(this, "shortcut-new-event")
                .setLongLived()
                .setShortLabel(getString(R.string.new_event_tonight))
                .setLongLabel(getString(R.string.new_event_tonight))
                .setIntent(buildNewEventTomorrowIntent())
                .setIcon(IconCompat.createWithResource(this, R.drawable.ic_add))
                .build()
    }

    private fun buildNewEventTomorrowIntent(): Intent {
        val intent = Intent(Intent.ACTION_INSERT)
        intent.data = CalendarContract.Events.CONTENT_URI
        val day = DateTime.now().withTimeAtStartOfDay()
        val startTime = day.plusHours(18)
        val endTime = day.plusHours(22)
        intent.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime.millis)
        intent.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.millis)
        return intent
    }
}