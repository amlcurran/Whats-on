package uk.co.amlcurran.social;

public interface EventsRepository {
    EventRepositoryAccessor queryEvents(TimeOfDay fivePm, TimeOfDay elevenPm,
                                        Timestamp searchStartTime, Timestamp searchEndTime);
}
