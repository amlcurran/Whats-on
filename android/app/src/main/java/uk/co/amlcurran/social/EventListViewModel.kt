package uk.co.amlcurran.social

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.datetime.Clock
import uk.co.amlcurran.starlinginterview.AsyncResult
import uk.co.amlcurran.starlinginterview.failureWith
import uk.co.amlcurran.starlinginterview.successOf

class EventListViewModel(application: Application): AndroidViewModel(application) {

    private val _source = MutableStateFlow<AsyncResult<CalendarSource>>(
        AsyncResult.Loading()
    )
    val source: StateFlow<AsyncResult<CalendarSource>> = _source
    private val eventsRepository: AndroidEventsRepository by lazy { AndroidEventsRepository(application.contentResolver) }
    private val eventsService: EventsService by lazy { EventsService(eventsRepository, JodaCalculator(), UserSettings(application), EventPredicates(UserSettings(application)).defaultPredicate) }

    init {
        viewModelScope.launch {
            load()
        }
    }

    suspend fun load() {
        try {
            val timestamp = Clock.System.now()
            val it = eventsService.getCalendarSource(14, timestamp)
            _source.emit(successOf(it))
        } catch (e: Throwable) {
            _source.emit(failureWith(e))
        }
    }

}