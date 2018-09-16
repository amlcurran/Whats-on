package uk.co.amlcurran.social;

import javax.annotation.Nonnull;

public class EmptyCalendarItem implements CalendarItem {

    private final Timestamp startTime;
    private final Timestamp endTime;

    public EmptyCalendarItem(Timestamp startTime, Timestamp endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
    }

    @Nonnull
    @Override
    public String title() {
        return "Empty";
    }

    @Nonnull
    @Override
    public Timestamp startTime() {
        return startTime;
    }

    @Nonnull
    @Override
    public Timestamp endTime() {
        return endTime;
    }

    @Override
    public boolean isEmpty() {
        return true;
    }
}
