package uk.co.amlcurran.social

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch
import org.joda.time.DateTime
import org.joda.time.DateTimeZone
import uk.co.amlcurran.starlinginterview.AsyncResult
import uk.co.amlcurran.starlinginterview.failureWith
import uk.co.amlcurran.starlinginterview.successOf

class EventListViewModel(application: Application): AndroidViewModel(application) {

    val source = MutableStateFlow<AsyncResult<CalendarSource>>(
        AsyncResult.Loading()
    )
    private val eventsRepository: AndroidEventsRepository by lazy { AndroidEventsRepository(application.contentResolver) }
    private val eventsService: EventsService by lazy { EventsService(eventsRepository, JodaCalculator(), UserSettings(application), EventPredicates(UserSettings(application)).defaultPredicate) }

    init {
        viewModelScope.launch {
            load()
        }
    }

    suspend fun load() {
        try {
            val now = DateTime.now(DateTimeZone.getDefault())
            val timestamp = Timestamp(now.millis)
            val it = eventsService.getCalendarSource(14, timestamp)
            source.emit(successOf(it))
        } catch (e: Throwable) {
            source.emit(failureWith(e))
        }
    }

}