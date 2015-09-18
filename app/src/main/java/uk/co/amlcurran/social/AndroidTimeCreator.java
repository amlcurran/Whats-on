package uk.co.amlcurran.social;

import org.joda.time.DateTime;

public class AndroidTimeCreator implements TimeCreator {

    @Override
    public int endOfBorderTimeInMinutes() {
        return 23 * 60;
    }

    @Override
    public int startOfBorderTimeInMinutes() {
        return 17 * 60;
    }

    @Override
    public long startOfDayPlusDays(DateTime now, int numberOfDays) {
        return now.withTimeAtStartOfDay().plusDays(numberOfDays).getMillis();
    }

    @Override
    public Time startOfToday() {
        return new Time(DateTime.now().withTimeAtStartOfDay());
    }
}