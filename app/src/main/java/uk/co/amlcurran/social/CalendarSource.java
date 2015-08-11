package uk.co.amlcurran.social;

import android.support.v4.util.SparseArrayCompat;

import uk.co.amlcurran.social.bootstrap.ItemSource;

class CalendarSource implements ItemSource<CalendarItem> {

    private final SparseArrayCompat<CalendarItem> calendarItems;
    private final int daysSize;

    public CalendarSource(SparseArrayCompat<CalendarItem> calendarItems, int daysSize) {
        this.calendarItems = calendarItems;
        this.daysSize = daysSize;
    }

    @Override
    public int count() {
        return daysSize;
    }

    @Override
    public CalendarItem itemAt(int position) {
        return calendarItems.get(position);
    }

    public boolean isEmptyAt(int position) {
        return calendarItems.get(position) == null;
    }
}
