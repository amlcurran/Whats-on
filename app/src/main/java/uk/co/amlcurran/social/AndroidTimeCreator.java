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
    public Time startOfToday() {
        return new JodaTime(DateTime.now().withTimeAtStartOfDay());
    }
}