package uk.co.amlcurran.social

import android.content.Context
import android.content.SharedPreferences
import androidx.preference.PreferenceManager

class AndroidTimeRepository(context: Context) : TimeRepository {

    private val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)

    override fun borderTimeStart() = sharedPreferences.getInt("startTime", 18).let { TimeOfDay.fromHours(it) }

    override fun borderTimeEnd() = sharedPreferences.getInt("endTime", 23).let { TimeOfDay.fromHours(it) }

    override fun updateStartTime(timeOfDay: TimeOfDay) = sharedPreferences.commit {
        putInt("startTime", timeOfDay.hoursInDay().toInt())
    }

    override fun updateEndTime(timeOfDay: TimeOfDay) = sharedPreferences.commit {
        putInt("endTime", timeOfDay.hoursInDay().toInt())
    }

}

private fun SharedPreferences.commit(function: SharedPreferences.Editor.() -> Unit) {
    val edit = edit()
    edit.function()
    edit.apply()
}
