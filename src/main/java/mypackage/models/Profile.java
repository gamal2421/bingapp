package mypackage.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mypackage.utl.DataBase;

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

    public int getTotalPoints(int userId) {
        int totalPoints = 0;
        try (Connection conn = DataBase.getConnection()) {
            String sql = "SELECT SUM(score) AS total_points FROM game_results WHERE emp_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    totalPoints = rs.getInt("total_points");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalPoints;
    }

    public void setTotalPoints(int totalPoints) {
        this.totalPoints = totalPoints;
    }

    public List<Booking> getUpcomingBookings(int userId) {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DataBase.getConnection()) {
            String sql = "SELECT b.booking_id, b.game_date, b.game_type, s.start_time, s.end_time " +
                         "FROM booking_game b JOIN slots s ON b.slot_id = s.slot_id " +
                         "WHERE b.booking_id IN (SELECT book_id FROM Emp_booking WHERE emp_id = ?) " +
                         "AND b.game_date > CURRENT_DATE";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Booking booking = new Booking(
                        rs.getInt("booking_id"),
                        rs.getDate("game_date"),
                        rs.getString("game_type"),
                        rs.getString("start_time"),
                        rs.getString("end_time"),
                        rs.getString("status")
                    );
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
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
}
