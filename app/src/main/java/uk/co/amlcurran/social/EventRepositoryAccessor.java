package uk.co.amlcurran.social;

public interface EventRepositoryAccessor {
    String getTitle();

    long getDtStart();

    String getEventIdentifier();

    boolean nextItem();

    void endAccess();
}
