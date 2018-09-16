package uk.co.amlcurran.social;

import javax.annotation.Nonnull;

public interface CalendarItem {

    @Nonnull
    String title();

    @Nonnull
    Timestamp startTime();

    @Nonnull
    Timestamp endTime();

    boolean isEmpty();
}
