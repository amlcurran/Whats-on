package uk.co.amlcurran.social;

public interface EventsRepository {
    EventRepositoryAccessor queryEvents(TimeOfDay fivePm, TimeOfDay elevenPm,
                                        Time searchStartTime, Time searchEndTime);
}
