package uk.co.amlcurran.social

class AndroidTimeRepository : TimeRepository {

    override fun borderTimeEnd() = TimeOfDay.fromHours(23)

    override fun borderTimeStart() = TimeOfDay.fromHours(18)

}