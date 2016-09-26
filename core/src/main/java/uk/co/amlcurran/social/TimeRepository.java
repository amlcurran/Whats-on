package uk.co.amlcurran.social;

public interface TimeRepository {
    TimeOfDay borderTimeEnd();

    TimeOfDay borderTimeStart();

    Timestamp startOfToday();
}
