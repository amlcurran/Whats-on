package uk.co.amlcurran.social.widget

import android.content.Context
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.work.CoroutineWorker
import androidx.work.OneTimeWorkRequest
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.Calendar

class WidgetUpdateWorker(appContext: Context, workerParams: WorkerParameters):
    CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result {
        val manager = GlanceAppWidgetManager(applicationContext)
        val widget = NextWeekWidget()
        val glanceIds = manager.getGlanceIds(NextWeekWidget::class.java)
        glanceIds.forEach { glanceId ->
            widget.update(applicationContext, glanceId)
        }
        val dailyWorkRequest = buildWorkRequest()
        WorkManager.getInstance(applicationContext)
            .enqueue(dailyWorkRequest)
        return Result.success()
    }

    companion object {

        fun buildWorkRequest(): OneTimeWorkRequest {
            val currentDate = Calendar.getInstance()
            val dueDate = Calendar.getInstance()
            // Set Execution around 05:00:00 AM
            dueDate.set(Calendar.HOUR_OF_DAY, 0)
            dueDate.set(Calendar.MINUTE, 5)
            dueDate.set(Calendar.SECOND, 0)
            if (dueDate.before(currentDate)) {
                dueDate.add(Calendar.HOUR_OF_DAY, 24)
            }
            val timeDiff = dueDate.timeInMillis - currentDate.timeInMillis
            val dailyWorkRequest = OneTimeWorkRequestBuilder<WidgetUpdateWorker>()
                .setInitialDelay(timeDiff, java.util.concurrent.TimeUnit.MILLISECONDS)
                .build()
            return dailyWorkRequest
        }
    }

}