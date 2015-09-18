package uk.co.amlcurran.social;

public interface TimeCreator {
    int endOfBorderTimeInMinutes();

    int startOfBorderTimeInMinutes();

    Time startOfToday();
}
