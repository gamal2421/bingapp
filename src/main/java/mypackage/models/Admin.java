package mypackage.models;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import mypackage.utl.DataBase;

public class Admin extends User {

    public Admin(int id, String firstName, String lastName, String gender, Date dob) {
        super(id, firstName, lastName, gender, dob);
    }

    // Delete a user or booking, depending on what you need
   // Delete an employee, booking, or game result
public void delete(int entityId, String entityType) {
    try (Connection conn = DataBase.getConnection()) {
        String sql = "";
        
        if (entityType.equals("employee")) {
            sql = "DELETE FROM emp_master_data WHERE emp_id = ?";
        } else if (entityType.equals("booking")) {
            sql = "DELETE FROM booking_game WHERE booking_id = ?";
        } else if (entityType.equals("game_result")) {
            sql = "DELETE FROM game_results WHERE result_id = ?";
        } else {
            throw new IllegalArgumentException("Invalid entity type");
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, entityId);
            stmt.executeUpdate();
            System.out.println("Entity with ID " + entityId + " deleted.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}


    // Admin can book for others by specifying user id and booking details
// Admin books a game for another employee
public void bookForOthers(int empId, Date gameDate, String gameType, int slotId) {
    try (Connection conn = DataBase.getConnection()) {
        // Step 1: Check if the slot is available or if any holidays conflict
        String checkHolidaySql = "SELECT * FROM holidays WHERE day_date = ?";
        try (PreparedStatement holidayStmt = conn.prepareStatement(checkHolidaySql)) {
            holidayStmt.setDate(1, new java.sql.Date(gameDate.getTime()));
            ResultSet holidayRs = holidayStmt.executeQuery();
            if (holidayRs.next()) {
                System.out.println("Cannot book game, this day is a holiday.");
                return;
            }
        }

        // Step 2: Insert a new booking into the booking_game table
        String bookingSql = "INSERT INTO booking_game (game_date, game_type, status, slot_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
            stmt.setString(2, gameType);
            stmt.setString(3, "booked");
            stmt.setInt(4, slotId);
            stmt.executeUpdate();
            
            // Get the generated booking_id
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int bookingId = generatedKeys.getInt(1);
                System.out.println("Booking created for employee with ID " + empId + " on " + gameDate);
                
                // Step 3: Insert into Emp_booking table to link employee and booking
                String empBookingSql = "INSERT INTO Emp_booking (emp_id, book_id) VALUES (?, ?)";
                try (PreparedStatement empBookingStmt = conn.prepareStatement(empBookingSql)) {
                    empBookingStmt.setInt(1, empId);
                    empBookingStmt.setInt(2, bookingId);
                    empBookingStmt.executeUpdate();
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}



    // View report of bookings 
    public static List<Map<String, String>> viewReport(Date date) {
        List<Map<String, String>> reportList = new ArrayList<>();
        String sql = "SELECT " +
                     "s.start_time || '-' || s.end_time AS slot_time, " +
                     "STRING_AGG(e.first_name || ' ' || e.last_name, ' : ' ORDER BY e.first_name) AS players " +
                     "FROM emp_master_data e " +
                     "JOIN emp_booking eb ON e.emp_id = eb.emp_id " +
                     "JOIN booking_game b ON eb.book_id = b.booking_id " +
                     "JOIN slots s ON b.slot_id = s.slot_id " +
                     "WHERE b.game_date = ? " +
                     "GROUP BY s.start_time, s.end_time " +
                     "ORDER BY s.start_time";

        try (Connection conn = DataBase.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, new java.sql.Date(date.getTime()));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> record = new HashMap<>();
                record.put("slot_time", rs.getString("slot_time"));
                record.put("players", rs.getString("players"));
                reportList.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reportList;
    }
    

  // Modify the time slot for an existing booking
public void modifySlot(int bookingId, int newSlotId) {
    try (Connection conn = DataBase.getConnection()) {
        String sql = "UPDATE booking_game SET slot_id = ? WHERE booking_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newSlotId);
            stmt.setInt(2, bookingId);
            stmt.executeUpdate();
            System.out.println("Booking ID " + bookingId + " slot updated to " + newSlotId);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}


    // Switch the time slot for a booking (e.g., user requests a time change)
 // Switch the time slot of a booking and ensure season time is considered
public void switchTime(int bookingId, int currentSlotId) {
    try (Connection conn = DataBase.getConnection()) {
        // Step 1: Get the current season time of the booking's time slot
        String currentSeasonTimeSql = "SELECT s.season_time FROM booking_game b " +
                                      "JOIN slots s ON b.slot_id = s.slot_id WHERE b.booking_id = ?";
        String currentSeasonTime = null;
        try (PreparedStatement stmt = conn.prepareStatement(currentSeasonTimeSql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                currentSeasonTime = rs.getString("season_time");
            }
        }

        // Step 2: If the current season time is "regular", find available "ramadan" slots
        if ("regular".equals(currentSeasonTime)) {
            String ramadanSlotsSql = "SELECT slot_id FROM slots WHERE season_time = 'ramadan' AND slot_id != ?";
            try (PreparedStatement stmt = conn.prepareStatement(ramadanSlotsSql)) {
                stmt.setInt(1, currentSlotId);  // Ensure not switching to the same slot
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    int ramadanSlotId = rs.getInt("slot_id");

                    // Step 3: Update the booking to the new Ramadan time slot
                    String updateBookingSql = "UPDATE booking_game SET slot_id = ? WHERE booking_id = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateBookingSql)) {
                        updateStmt.setInt(1, ramadanSlotId);
                        updateStmt.setInt(2, bookingId);
                        updateStmt.executeUpdate();
                        System.out.println("Booking ID " + bookingId + " has been switched to Ramadan slot ID " + ramadanSlotId);
                    }
                } else {
                    System.out.println("No available Ramadan slots to switch to.");
                }
            }
        } else {
            System.out.println("Current season time is not 'regular'. No action taken.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
   }
}

}
