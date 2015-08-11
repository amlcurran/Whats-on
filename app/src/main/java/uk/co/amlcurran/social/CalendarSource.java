package uk.co.amlcurran.social;

import java.util.List;

import uk.co.amlcurran.social.bootstrap.ItemSource;

class CalendarSource implements ItemSource<CalendarItem> {

    private final List<CalendarItem> calendarItems;
    private final int daysSize;

    public CalendarSource(List<CalendarItem> calendarItems, int daysSize) {
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
        return position >= calendarItems.size();
    }
}
