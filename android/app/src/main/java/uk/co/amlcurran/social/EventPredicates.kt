package uk.co.amlcurran.social

import android.provider.CalendarContract.Attendees.ATTENDEE_STATUS_DECLINED
import android.provider.CalendarContract.Attendees.ATTENDEE_STATUS_INVITED

class EventPredicates(
    private val userSettings: UserSettings,
) {

    val defaultPredicate = compoundPredicate(
        EventPredicate("notAllDay") { it.allDay.not() },
        EventPredicate("notDeclined") { it.attendingStatus != ATTENDEE_STATUS_DECLINED },
        EventPredicate("notDeleted") { it.isDeleted.not() },
        EventPredicate("tentativeOrShown") {
            userSettings.showTentativeMeetings() || it.attendingStatus != ATTENDEE_STATUS_INVITED
        },
        EventPredicate("hiddenEvent") { userSettings.shouldShowEvent(it.eventId) },
        EventPredicate("inHiddenCalendar") { userSettings.showEventsFrom(it.calendarId) }
    )

}

private fun compoundPredicate(vararg predicates: EventPredicate): EventPredicate {
    return EventPredicate("compound") { event ->
        println(event.title)
        predicates.fold(true) { current, predicate ->
            val result = predicate.predicate(event)
            println("- ${predicate.id}: $result")
            result && current
        }
    }
}