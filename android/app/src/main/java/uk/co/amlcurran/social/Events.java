package uk.co.amlcurran.social;

import rx.Observable;
import rx.Observer;
import rx.Scheduler;
import rx.Subscriber;

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
        Observable.create(new Observable.OnSubscribe<CalendarSource>() {
            @Override
            public void call(Subscriber<? super CalendarSource> subscriber) {
                CalendarSource calendarSource = eventsService.getCalendarSource(14, now);
                subscriber.onNext(calendarSource);
                subscriber.onCompleted();
            }
        })
                .subscribeOn(mainThread)
                .observeOn(workerThread)
                .subscribe(calendarSourceObserver);
    }

}
