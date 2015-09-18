package uk.co.amlcurran.social;

import rx.Subscriber;

public interface EventsRepository {
    EventRepositoryAccessor queryEvents(Subscriber<? super EventRepositoryAccessor> subscriber, long fivePm, long elevenPm,
                                        Time searchStartTime, Time searchEndTime);
}
