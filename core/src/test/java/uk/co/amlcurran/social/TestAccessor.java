package uk.co.amlcurran.social;

import java.util.List;

class TestAccessor implements EventRepositoryAccessor {

    private final List<String> eventIds;
    private int currentPosition = -1;

    TestAccessor(List<String> eventIds) {
        this.eventIds = eventIds;
    }

    @Override
    public String getTitle() {
        return "Test title";
    }

    @Override
    public String getEventIdentifier() {
        return eventIds.get(currentPosition);
    }

    @Override
    public boolean nextItem() {
        currentPosition++;
        return currentPosition < eventIds.size();
    }

    @Override
    public void endAccess() {

    }

    @Override
    public Timestamp getStartTime() {
        return new Timestamp(17 * 60 * 60 * 1000, new TestCalculator());
    }

    @Override
    public Timestamp getEndTime() {
        return new Timestamp(19 * 60 * 60 * 1000, new TestCalculator());
    }
}
