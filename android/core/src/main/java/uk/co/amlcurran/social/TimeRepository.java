package uk.co.amlcurran.social;

import javax.annotation.Nonnull;

public interface TimeRepository {

    @Nonnull
    TimeOfDay borderTimeEnd();

    @Nonnull
    TimeOfDay borderTimeStart();

}
