package uk.co.amlcurran.social;

public interface CalendarItem {

    String title();

    Time startTime();

    Time endTime();

    boolean isEmpty();
}
