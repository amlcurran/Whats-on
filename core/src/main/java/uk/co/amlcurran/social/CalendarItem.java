package uk.co.amlcurran.social;

public interface CalendarItem {

    String title();

    int startDay();

    Time startTime();

    boolean isEmpty();
}
