package uk.co.amlcurran.social;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;

public class TimePickerActivity extends AppCompatActivity {

    public static void start(Activity activity) {
        Intent intent = new Intent(activity, TimePickerActivity.class);
        activity.startActivity(intent);
    }

}
