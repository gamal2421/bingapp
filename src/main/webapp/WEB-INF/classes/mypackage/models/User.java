package mypackage.models;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import mypackage.utl.DataBase;

public class User {
    protected int id;
    protected String firstName;
    protected String lastName;
    protected String gender;
    protected Date dob;


public boolean login(int userId, String password) {
    try (Connection conn = DataBase.getConnection()) {
        String sql = "SELECT * FROM emp_master_data WHERE emp_id = ? AND password = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("Login successful for user: " + rs.getString("first_name"));
                return true;
            } else {
                System.out.println("Invalid login credentials.");
                return false;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public void book(int empId, Date gameDate, String gameType, int slotId) {
    try (Connection conn = DataBase.getConnection()) {
        // Step 1: Check if the slot is available and not already booked
        String checkAvailabilitySql = "SELECT * FROM booking_game WHERE game_date = ? AND slot_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkAvailabilitySql)) {
            stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
            stmt.setInt(2, slotId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("Slot already booked for the selected date.");
                return;
            }
        }

        // Step 2: Insert a new booking record
        String bookingSql = "INSERT INTO booking_game (game_date, game_type, status, slot_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
            stmt.setString(2, gameType);
            stmt.setString(3, "booked");
            stmt.setInt(4, slotId);
            stmt.executeUpdate();

            // Get the generated booking ID
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int bookingId = generatedKeys.getInt(1);
                System.out.println("Booking created with ID " + bookingId);

                // Step 3: Link the booking to the employee
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

public void seeAvailableSlots(Date gameDate) {
    try (Connection conn = DataBase.getConnection()) {
        String sql = "SELECT s.slot_id, s.start_time, s.end_time, s.season_time " +
                     "FROM slots s WHERE s.slot_id NOT IN (SELECT slot_id FROM booking_game WHERE game_date = ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int slotId = rs.getInt("slot_id");
                String startTime = rs.getString("start_time");
                String endTime = rs.getString("end_time");
                String seasonTime = rs.getString("season_time");
                System.out.println("Slot ID: " + slotId + " | Start: " + startTime + " | End: " + endTime + " | Season: " + seasonTime);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

public void cancelSlot(int bookingId) {
    try (Connection conn = DataBase.getConnection()) {
        // Step 1: Remove the booking from the Emp_booking table
        String empBookingSql = "DELETE FROM Emp_booking WHERE book_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(empBookingSql)) {
            stmt.setInt(1, bookingId);
            stmt.executeUpdate();
        }

        // Step 2: Remove the booking from the booking_game table
        String bookingSql = "DELETE FROM booking_game WHERE booking_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(bookingSql)) {
            stmt.setInt(1, bookingId);
            stmt.executeUpdate();
            System.out.println("Booking ID " + bookingId + " has been canceled.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

public void showBookedSlots(int empId) {
    try (Connection conn = DataBase.getConnection()) {
        String sql = "SELECT b.booking_id, b.game_date, b.game_type, s.start_time, s.end_time " +
                     "FROM booking_game b JOIN slots s ON b.slot_id = s.slot_id " +
                     "WHERE b.booking_id IN (SELECT book_id FROM Emp_booking WHERE emp_id = ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, empId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int bookingId = rs.getInt("booking_id");
                Date gameDate = rs.getDate("game_date");
                String gameType = rs.getString("game_type");
                String startTime = rs.getString("start_time");
                String endTime = rs.getString("end_time");
                System.out.println("Booking ID: " + bookingId + " | Date: " + gameDate + " | Game: " + gameType + 
                                   " | Start: " + startTime + " | End: " + endTime);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}


    public User(int id, String firstName, String lastName , String gender, Date dob ) {
        this.dob = dob;
        this.firstName = firstName;
        this.gender = gender;
        this.id = id;
        this.lastName = lastName;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
