package uk.co.amlcurran.social

interface TimeRepository {

    fun borderTimeEnd(): TimeOfDay

    fun borderTimeStart(): TimeOfDay

}
