package uk.co.amlcurran.social;

import uk.co.amlcurran.social.core.SparseArray;

class CalendarSource {

    private final TimeRepository timeRepository;
    private final SparseArray<CalendarItem> calendarItems;
    private final int daysSize;
    private final Time now;

    public CalendarSource(TimeRepository timeRepository, SparseArray<CalendarItem> calendarItems, int daysSize, Time now) {
        this.timeRepository = timeRepository;
        this.calendarItems = calendarItems;
        this.daysSize = daysSize;
        this.now = now;
    }

    public int count() {
        return daysSize;
    }

    public CalendarItem itemAt(int position) {
        CalendarItem calendarItem = calendarItems.get(position);
        if (calendarItem == null) {
            return new EmptyCalendarItem(position, timeRepository.startOfToday().plusDays(position).plusHours(17));
        }
        return calendarItem;
    }

    public boolean isEmptyAt(int position) {
        return calendarItems.get(position) == null;
    }
}
