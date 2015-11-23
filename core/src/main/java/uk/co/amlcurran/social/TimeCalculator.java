package uk.co.amlcurran.social;

public interface TimeCalculator {
    Time plusDays(int days, Time time);

    int getDays(Time time);

    Time plusHours(Time time, int hours);
}
