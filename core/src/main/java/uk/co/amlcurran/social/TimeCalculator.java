package uk.co.amlcurran.social;

public interface TimeCalculator {
    Timestamp plusDays(int days, Timestamp time);

    int getDays(Timestamp time);

    Timestamp plusHours(Timestamp time, int hours);
}
