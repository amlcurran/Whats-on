package uk.co.amlcurran.social;

public interface EventRepositoryAccessor {
    String getTitle();

    String getEventIdentifier();

    boolean nextItem();

    Timestamp getStartTime();

    Timestamp getEndTime();

    String getCalendarId();

    String getString(String columnName);
}
