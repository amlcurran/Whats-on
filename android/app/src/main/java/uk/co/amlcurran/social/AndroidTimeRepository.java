package uk.co.amlcurran.social;

public class AndroidTimeRepository implements TimeRepository {

    @Override
    public TimeOfDay borderTimeEnd() {
        return TimeOfDay.Companion.fromHours(23);
    }

    @Override
    public TimeOfDay borderTimeStart() {
        return TimeOfDay.Companion.fromHours(18);
    }

}