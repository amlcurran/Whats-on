package uk.co.amlcurran.social.add

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import uk.co.amlcurran.social.R

class AddEventActivity: AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_host)

        supportFragmentManager.beginTransaction()
            .replace(R.id.activity_add_event, AddEventFragment())
            .commit()
    }

}