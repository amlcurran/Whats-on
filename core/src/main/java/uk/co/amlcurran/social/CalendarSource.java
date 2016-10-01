package uk.co.amlcurran.social;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

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

    @Nullable
    public CalendarItem itemAt(int position) {
        CalendarSlot calendarSlot = calendarItems.get(position);
        if (calendarSlot == null || calendarSlot.isEmpty()) {
            Timestamp startTime = startOfTodayBlock(position);
            Timestamp endTime = endOfTodayBlock(position);
            return new EmptyCalendarItem(startTime, endTime);
        }
        return calendarSlot.firstItem();
    }

    @Nonnull
    private Timestamp startOfTodayBlock(int position) {
        return timeRepository.startOfToday().plusDays(position).plusHours(17);
    }

    @Nonnull
    private Timestamp endOfTodayBlock(int position) {
        return timeRepository.startOfToday().plusDays(position).plusHours(23);
    }

    @Nonnull
    public CalendarSlot slotAt(int position) {
        return calendarItems.get(position, new CalendarSlot());
    }

    public boolean isEmptySlot(int position) {
        return slotAt(position).isEmpty();
    }
}
