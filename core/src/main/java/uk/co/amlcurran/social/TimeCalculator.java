package uk.co.amlcurran.social;

import javax.annotation.Nonnull;

public interface TimeCalculator {

    @Nonnull
    Timestamp plusDays(int days, Timestamp time);

    int getDays(Timestamp time);

    @Nonnull
    Timestamp plusHours(Timestamp time, int hours);
}
