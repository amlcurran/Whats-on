package uk.co.amlcurran.social;

import org.joda.time.DateTime;

public class DateCreator {

    int endOfBorderTimeInMinutes() {
        return 23 * 60;
    }

    int startOfBorderTimeInMinutes() {
        return 17 * 60;
    }

    long startOfDayPlusDays(DateTime now, int numberOfDays) {
        return now.withTimeAtStartOfDay().plusDays(numberOfDays).getMillis();
    }

    long startOfDay(DateTime now) {
        return now.withTimeAtStartOfDay().getMillis();
    }
}