package uk.co.amlcurran.social;

import org.joda.time.DateTime;

public interface TimeCreator {
    int endOfBorderTimeInMinutes();

    int startOfBorderTimeInMinutes();

    long startOfDayPlusDays(DateTime now, int numberOfDays);

    Time startOfToday();
}
