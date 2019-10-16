package uk.co.amlcurran.social

import io.reactivex.*

class Events(private val mainThread: Scheduler, private val workerThread: Scheduler, private val eventsService: EventsService) {

    fun load(now: Timestamp): Single<CalendarSource> {
        return Single.fromCallable { eventsService.getCalendarSource(14, now) }
                .subscribeOn(mainThread)
                .observeOn(workerThread)
    }

}
