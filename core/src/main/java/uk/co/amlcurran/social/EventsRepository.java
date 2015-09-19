package uk.co.amlcurran.social;

public interface EventsRepository {
    EventRepositoryAccessor queryEvents(long fivePm, long elevenPm,
                                        Time searchStartTime, Time searchEndTime);
}
