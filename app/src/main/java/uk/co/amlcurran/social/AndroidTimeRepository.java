package uk.co.amlcurran.social;

import org.joda.time.DateTime;

public class AndroidTimeRepository implements TimeRepository {

    @Override
    public TimeOfDay borderTimeEnd() {
        return TimeOfDay.fromHours(23);
    }

    @Override
    public TimeOfDay borderTimeStart() {
        return TimeOfDay.fromHours(17);
    }

    @Override
    public Timestamp startOfToday() {
        return new Timestamp(DateTime.now().withTimeAtStartOfDay().getMillis(), new JodaCalculator());
    }
}