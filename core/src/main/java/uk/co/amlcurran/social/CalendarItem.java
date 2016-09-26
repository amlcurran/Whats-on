package uk.co.amlcurran.social;

public interface CalendarItem {

    String title();

    Timestamp startTime();

    Timestamp endTime();

    boolean isEmpty();
}
