package uk.co.amlcurran.social;

public interface Time {
    Time plusDays(int days);

    int daysSinceEpoch();

    long getMillis();
}
