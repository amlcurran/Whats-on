package uk.co.amlcurran.social;

public interface EventRepositoryAccessor {
    String getTitle();

    String getEventIdentifier();

    boolean nextItem();

    void endAccess();

    Time getStartTime();

    Time getEndTime();
}
