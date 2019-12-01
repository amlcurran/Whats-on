package uk.co.amlcurran.social

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class SettingsActivity : AppCompatActivity(), SettingsDelegate {

    companion object {

        fun start(activity: Activity) {
            val intent = Intent(activity, SettingsActivity::class.java)
            activity.startActivity(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_settings)

        supportFragmentManager.beginTransaction()
            .add(R.id.settingsFrame, SettingsFragment())
            .commit()
    }

    override fun closeSettings() = finish()

    override fun onCalendarSettingsChanged() { }

}

