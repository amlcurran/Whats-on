package uk.co.amlcurran.social

import io.reactivex.Completable
import io.reactivex.Scheduler
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers
import java.util.concurrent.TimeUnit

class Events(
        private val mainThread: Scheduler = AndroidSchedulers.mainThread(),
        private val workerThread: Scheduler = Schedulers.io(),
        private val eventsService: EventsService
) {

    fun load(now: Timestamp, delay: Long): Single<CalendarSource> {
        return Single.fromCallable { eventsService.getCalendarSource(14, now) }
                .delay(delay, TimeUnit.MILLISECONDS)
                .subscribeOn(workerThread)
                .observeOn(mainThread)
    }

    fun loadSingleEvent(eventId: String): Single<Event> {
        return Single.create<Event> {
            val event = eventsService.eventWithId(eventId)
            if (event != null) {
                it.onSuccess(event)
            } else {
                it.onError(NoSuchElementException("No event with the id $eventId"))
            }
        }
                .subscribeOn(workerThread)
                .observeOn(mainThread)
    }

    fun delete(eventId: String): Completable {
        return Completable.create {
            val deleted = eventsService.delete(eventId)
            if (deleted) {
                it.onComplete()
            } else {
                it.onError(NoSuchElementException("Couldn't delete event with id $eventId"))
            }
        }
    }

}
