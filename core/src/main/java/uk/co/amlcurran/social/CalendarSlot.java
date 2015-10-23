package uk.co.amlcurran.social;

public class CalendarSlot {
    private CalendarItem item;

    public CalendarItem item() {
        return item;
    }

    public void addItem(CalendarItem item) {
        this.item = item;
    }
}
