package mypackage.models;
import java.util.List;

public class Profile {
    private int userId;
    private int totalPoints;
    private List<Booking> upcomingBookings;
    private List<Booking> historyBookings;


    public List<Booking> getHistoryBookings() {
        return historyBookings;
    }

    public void setHistoryBookings(List<Booking> historyBookings) {
        this.historyBookings = historyBookings;
    }

    public int getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(int totalPoints) {
        this.totalPoints = totalPoints;
    }

    public List<Booking> getUpcomingBookings() {
        return upcomingBookings;
    }

    public void setUpcomingBookings(List<Booking> upcomingBookings) {
        this.upcomingBookings = upcomingBookings;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
    // Constructors, Getters, Setters
}
