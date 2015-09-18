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

    Time startOfToday(DateTime now) {
        return new Time(DateTime.now().withTimeAtStartOfDay());
    }
}