package uk.co.amlcurran.social;

public interface TimeRepository {
    int endOfBorderTimeInMinutes();

    int startOfBorderTimeInMinutes();

    Time startOfToday();
}
