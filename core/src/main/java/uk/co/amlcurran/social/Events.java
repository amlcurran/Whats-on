package uk.co.amlcurran.social;

import rx.Observer;
import rx.Scheduler;

public class Events {
    private final EventsRepository eventsRepository;
    private final TimeRepository dateCreator;
    private final Scheduler mainThread;
    private final Scheduler workerThread;

    public Events(EventsRepository eventsRepository, TimeRepository dateCreator, Scheduler mainThread, Scheduler workerThread) {
        this.eventsRepository = eventsRepository;
        this.dateCreator = dateCreator;
        this.mainThread = mainThread;
        this.workerThread = workerThread;
    }

    public void load(Time now, Observer<CalendarSource> calendarSourceObserver) {
        new EventsService(dateCreator, eventsRepository)
                .queryEventsFrom(now, 14)
                .subscribeOn(mainThread)
                .observeOn(workerThread)
                .subscribe(calendarSourceObserver);
    }

}
