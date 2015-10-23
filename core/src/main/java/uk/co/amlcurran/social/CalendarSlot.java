package uk.co.amlcurran.social;

import java.util.ArrayList;
import java.util.List;

public class CalendarSlot {
    private final List<CalendarItem> calendarItems = new ArrayList<>();

    public CalendarItem firstItem() {
        return calendarItems.get(0);
    }

    public void addItem(CalendarItem item) {
        this.calendarItems.add(item);
    }

    public int count() {
        return calendarItems.size();
    }
}
