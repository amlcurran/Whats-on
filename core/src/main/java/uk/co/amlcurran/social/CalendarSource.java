package uk.co.amlcurran.social;

import uk.co.amlcurran.social.core.SparseArray;

class CalendarSource {

    private final TimeRepository timeRepository;
    private final SparseArray<CalendarSlot> calendarItems;
    private final int daysSize;

    public CalendarSource(TimeRepository timeRepository, SparseArray<CalendarSlot> calendarItems, int daysSize) {
        this.timeRepository = timeRepository;
        this.calendarItems = calendarItems;
        this.daysSize = daysSize;
    }

    public int count() {
        return daysSize;
    }

    public CalendarItem itemAt(int position) {
        CalendarItem calendarItem = calendarItems.get(position).firstItem();
        if (calendarItem == null) {
            return new EmptyCalendarItem(startOfTodayBlock(position), endOfTodayBlock(position));
        }
        return calendarItem;
    }

    private Time startOfTodayBlock(int position) {
        return timeRepository.startOfToday().plusDays(position).plusHours(17);
    }

    private Time endOfTodayBlock(int position) {
        return timeRepository.startOfToday().plusDays(position).plusHours(23);
    }

    public CalendarSlot slotAt(int position) {
        return calendarItems.get(position);
    }
}
