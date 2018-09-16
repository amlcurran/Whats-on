package uk.co.amlcurran.social;

public class AndroidTimeRepository implements TimeRepository {

    @Override
    public TimeOfDay borderTimeEnd() {
        return TimeOfDay.fromHours(23);
    }

    @Override
    public TimeOfDay borderTimeStart() {
        return TimeOfDay.fromHours(17);
    }

}