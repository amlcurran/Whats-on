package uk.co.amlcurran.social;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import uk.co.amlcurran.social.core.SparseArray;

class CalendarSource {

    private final SparseArray<CalendarSlot> calendarItems;
    private final int daysSize;
    private final TimeCalculator timeCalculator;

    public CalendarSource(SparseArray<CalendarSlot> calendarItems, int daysSize, TimeCalculator timeCalculator) {
        this.calendarItems = calendarItems;
        this.daysSize = daysSize;
        this.timeCalculator = timeCalculator;
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
        return timeCalculator.startOfToday().plusDays(position).plusHours(17);
    }

    @Nonnull
    private Timestamp endOfTodayBlock(int position) {
        return timeCalculator.startOfToday().plusDays(position).plusHours(23);
    }

    @Nonnull
    public CalendarSlot slotAt(int position) {
        return calendarItems.get(position, new CalendarSlot());
    }

    public boolean isEmptySlot(int position) {
        return slotAt(position).isEmpty();
    }
}
