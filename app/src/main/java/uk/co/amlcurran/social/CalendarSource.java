package uk.co.amlcurran.social;

import android.support.v4.util.SparseArrayCompat;

class CalendarSource {

    private final SparseArrayCompat<CalendarItem> calendarItems;
    private final int daysSize;
    private final Time now;

    public CalendarSource(SparseArrayCompat<CalendarItem> calendarItems, int daysSize, Time now) {
        this.calendarItems = calendarItems;
        this.daysSize = daysSize;
        this.now = now;
    }

    public int count() {
        return daysSize;
    }

    public CalendarItem itemAt(int position) {
        return calendarItems.get(position, new EmptyCalendarItem(position, now.plusDays(position)));
    }

    public boolean isEmptyAt(int position) {
        return calendarItems.get(position) == null;
    }
}
