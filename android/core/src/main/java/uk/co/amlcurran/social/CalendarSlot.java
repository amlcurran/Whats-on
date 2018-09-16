package uk.co.amlcurran.social;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

public class CalendarSlot {
    private final List<CalendarItem> calendarItems = new ArrayList<>();

    @Nullable
    public CalendarItem firstItem() {
        return calendarItems.get(0);
    }

    public void addItem(CalendarItem item) {
        this.calendarItems.add(item);
    }

    public int count() {
        return calendarItems.size();
    }

    public boolean isEmpty() {
        return calendarItems.isEmpty();
    }

    @Nonnull
    public List<CalendarItem> items() {
        return calendarItems;
    }
}
