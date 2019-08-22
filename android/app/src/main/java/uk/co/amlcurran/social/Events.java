package uk.co.amlcurran.social;

import org.reactivestreams.Subscriber;

import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.Observer;
import io.reactivex.Scheduler;

public class Events {
    private final Scheduler mainThread;
    private final Scheduler workerThread;
    private final EventsService eventsService;

    public Events(Scheduler mainThread, Scheduler workerThread, EventsService eventsService) {
        this.mainThread = mainThread;
        this.workerThread = workerThread;
        this.eventsService = eventsService;
    }

    public void load(final Timestamp now, Observer<CalendarSource> calendarSourceObserver) {
        Observable.create(new ObservableOnSubscribe<CalendarSource>() {
            @Override
            public void subscribe(ObservableEmitter<CalendarSource> emitter) {
                CalendarSource calendarSource = eventsService.getCalendarSource(14, now);
                emitter.onNext(calendarSource);
                emitter.onComplete();
            }

        })
                .subscribeOn(mainThread)
                .observeOn(workerThread)
                .subscribe(calendarSourceObserver);
    }

}
