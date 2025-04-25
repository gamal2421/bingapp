package mypackage.models;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import mypackage.utl.DataBase;

public class User {
    // User class fields
    protected int id;
    protected String firstName;
    protected String lastName;
    protected String gender;
    protected Date dob;
    private String role; // Add this line

    // Getter and Setter for role
    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // No-argument constructor (optional)
    public User() {
        // Default constructor, you can leave it empty or set default values if needed
    }

    // Constructor that takes parameters to initialize the User object
    public User(int id, String firstName, String lastName, String gender, Date dob) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.gender = gender;
        this.dob = dob;
    }

    // Method to login user
    public boolean login(String email, String password) {
        String sql = "SELECT * FROM emp_master_data WHERE email = ? AND password = ?";
        try (Connection conn = DataBase.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // load fields for session
                    this.id        = rs.getInt("emp_id");
                    this.firstName = rs.getString("first_name");
                    this.lastName  = rs.getString("last_name");
                    this.gender    = rs.getString("gender");
                    this.dob       = rs.getDate("dob");
                    this.role      = rs.getString("role"); // 🔥 Add this line!
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<String> getAllEmployeeFullNames() {
        List<String> fullNames = new ArrayList<>();
        String sql = "SELECT first_name || ' ' || last_name AS full_name FROM emp_master_data";
    
        try (Connection conn = DataBase.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
    
            while (rs.next()) {
                fullNames.add(rs.getString("full_name"));
            }
    
        } catch (SQLException e) {
            e.printStackTrace();
        }
    
        return fullNames;
    }
    // Method to book a game slot
    public void book(int empId, Date gameDate, String gameType, int slotId) {
        try (Connection conn = DataBase.getConnection()) {
            String bookingSql = "INSERT INTO booking_game (game_date, game_type, status, slot_id) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
                stmt.setString(2, gameType);
                stmt.setString(3, "pending");
                stmt.setInt(4, slotId);
                stmt.executeUpdate();

                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int bookingId = generatedKeys.getInt(1);
                    System.out.println("Booking created with ID " + bookingId);

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

    // Method to see available game slots
    public static List<String[]> seeAvailableSlots(java.util.Date gameDate) {
        List<String[]> slots = new ArrayList<>();
        try (Connection conn = DataBase.getConnection()) {
            String sql = "SELECT s.slot_id, s.start_time, s.end_time FROM slots s " +
                         "WHERE s.slot_id NOT IN (SELECT slot_id FROM booking_game WHERE game_date = ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String startTime = rs.getString("start_time");
                    String endTime = rs.getString("end_time");
                    slots.add(new String[]{startTime, endTime});
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return slots;
    }

    // Method to cancel a booked slot
    public void cancelSlot(int bookingId) {
        try (Connection conn = DataBase.getConnection()) {
            String empBookingSql = "DELETE FROM Emp_booking WHERE book_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(empBookingSql)) {
                stmt.setInt(1, bookingId);
                stmt.executeUpdate();
            }

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

    // Method to show booked game slots
    public List<Booking> showBookedSlots(int empId) {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DataBase.getConnection()) {
            String sql = "SELECT b.booking_id, b.game_date, s.start_time, s.end_time, b.game_type " +
                         "FROM booking_game b JOIN slots s ON b.slot_id = s.slot_id " +
                         "WHERE b.booking_id IN (SELECT book_id FROM Emp_booking WHERE emp_id = ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, empId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    int bookingId = rs.getInt("booking_id");
                    Date gameDate = rs.getDate("game_date");
                    String startTime = rs.getString("start_time");
                    String endTime = rs.getString("end_time");
                    String gameType = rs.getString("game_type");
                    bookings.add(new Booking(bookingId, gameDate, startTime, endTime, gameType));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    

    // Getter and setter methods for the User fields
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }
}
