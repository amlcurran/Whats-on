package uk.co.amlcurran.social;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;

public interface CalendarItem {
    DateTime EPOCH = new DateTime(0, DateTimeZone.getDefault());

    String title();

    int startDay();

    long startTime();

    boolean isEmpty();
}
