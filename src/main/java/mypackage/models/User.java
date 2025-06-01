package mypackage.models;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public boolean login(String email, String password) throws SQLException {
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
                    this.role      = rs.getString("role"); 
                    return true;
                }
            }
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
public List<String> getAllFemaleFullNames() {
    List<String> femaleNames = new ArrayList<>();
    String sql = "SELECT first_name || ' ' || last_name AS full_name FROM emp_master_data WHERE gender = 'Female'";
    
    try (Connection conn = DataBase.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
         
        while (rs.next()) {
            femaleNames.add(rs.getString("full_name"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return femaleNames;
}


    // // Method to book a game slot
    // public void book(int empId, Date gameDate, String gameType, int slotId) {
    //     try (Connection conn = DataBase.getConnection()) {
    //         String bookingSql = "INSERT INTO booking_game (game_date, game_type, status, slot_id) VALUES (?, ?, ?, ?)";
    //         try (PreparedStatement stmt = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
    //             stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
    //             stmt.setString(2, gameType);
    //             stmt.setString(3, "pending");
    //             stmt.setInt(4, slotId);
    //             stmt.executeUpdate();

    //             ResultSet generatedKeys = stmt.getGeneratedKeys();
    //             if (generatedKeys.next()) {
    //                 int bookingId = generatedKeys.getInt(1);
    //                 System.out.println("Booking created with ID " + bookingId);

    //                 String empBookingSql = "INSERT INTO Emp_booking (emp_id, book_id) VALUES (?, ?)";
    //                 try (PreparedStatement empBookingStmt = conn.prepareStatement(empBookingSql)) {
    //                     empBookingStmt.setInt(1, empId);
    //                     empBookingStmt.setInt(2, bookingId);
    //                     empBookingStmt.executeUpdate();
    //                 }
    //             }
    //         }
    //     } catch (SQLException e) {
    //         e.printStackTrace();
    //     }
    // }
    // Method to see available game slots for male
    public static List<String[]> seeAvailableSlots(java.util.Date gameDate) {
        List<String[]> slots = new ArrayList<>();
        try (Connection conn = DataBase.getConnection()) {
            String sql ="SELECT s.slot_id, TO_CHAR(s.start_time, 'HH24:MI') AS start_time, \n" + //
                                "  TO_CHAR(s.end_time, 'HH24:MI') AS end_time FROM slots s \n" + //
                                "     WHERE gender_group != 'female' and s.slot_id not in \n" + //
                                " (SELECT slot_id from booking_game where status ='pending' and game_date =? )";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int slotId = rs.getInt("slot_id");
                    String startTime = rs.getString("start_time");
                    String endTime = rs.getString("end_time");
                    slots.add(new String[]{startTime, endTime, String.valueOf(slotId)});
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return slots;
    }
     // Method to see available game slots for female
     public static List<String[]> femaleAvailableSlots(java.util.Date gameDate) {
        List<String[]> slots = new ArrayList<>();
        try (Connection conn = DataBase.getConnection()) {
            String sql ="SELECT s.slot_id, TO_CHAR(s.start_time, 'HH24:MI') AS start_time, \n" + //
                                "  TO_CHAR(s.end_time, 'HH24:MI') AS end_time FROM slots s " + //
                                "WHERE s.slot_id not in (SELECT slot_id from booking_game where status ='pending' and game_date = ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int slotId = rs.getInt("slot_id");
                    String startTime = rs.getString("start_time");
                    String endTime = rs.getString("end_time");
                    slots.add(new String[]{startTime, endTime, String.valueOf(slotId)});
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return slots;
    }

    // Method to see today's available game slots
    public static List<String[]> todayAvailableSlots(java.util.Date gameDate) {
        List<String[]> slots = new ArrayList<>();
        try (Connection conn = DataBase.getConnection()) {
            String sql = "SELECT s.slot_id, TO_CHAR(s.start_time, 'HH24:MI') AS start_time, \n" + //
                                "  TO_CHAR(s.end_time, 'HH24:MI') AS end_time FROM slots s " +
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
    public void cancelBooking(int bookingId) {
        try (Connection conn = DataBase.getConnection()) {
            String updateSql = "UPDATE booking_game SET status = 'cancelled' WHERE booking_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setInt(1, bookingId);
                updateStmt.executeUpdate();
                System.out.println("Booking cancelled for booking_id: " + bookingId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void confirmBooking(int bookingId) {
    try (Connection conn = DataBase.getConnection()) {
        String updateSql = "UPDATE booking_game SET status = 'confirmed' WHERE booking_id = ?";
        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
            updateStmt.setInt(1, bookingId);
            updateStmt.executeUpdate();
            System.out.println("Booking confirmed for booking_id: " + bookingId);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

    // Method to show booked game slots
    public List<Booking> showBookedSlots(int empId) {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DataBase.getConnection()) {
            String sql = "SELECT b.booking_id, b.game_date, s.start_time, s.end_time, b.game_type, b.status " +
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
                    String status = rs.getString("status");

                    bookings.add(new Booking(bookingId, gameDate, startTime, endTime, gameType, status));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // Method to get employee ID by full name
    public static int getEmployeeIdByName(String fullName) {
        int empId = -1; // Default to -1 if not found
        String sql = "SELECT emp_id FROM emp_master_data WHERE first_name || ' ' || last_name = ?";

        try (Connection conn = DataBase.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    empId = rs.getInt("emp_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return empId;
    }

   public static boolean canEmployeeBookSlots(String empName, Date gameDate, int numOfSlots) {
    int empId = getEmployeeIdByName(empName);
    if (empId == -1) {
        System.err.println("Employee not found: " + empName);
        return false;
    }

    String sql = "SELECT COUNT(b.booking_id) AS games_booked " +
                 "FROM booking_game b " +
                 "JOIN emp_booking eb ON b.booking_id = eb.book_id " +
                 "WHERE b.game_date = ? AND eb.emp_id = ?";

    try (Connection conn = DataBase.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setDate(1, new java.sql.Date(gameDate.getTime()));
        stmt.setInt(2, empId);

        try (ResultSet rs = stmt.executeQuery()) {
            int countGames = 0;
            if (rs.next()) {
                countGames = rs.getInt("games_booked");
            }

            // Check if total exceeds limit
            if (countGames + numOfSlots > 5) {
                System.err.println("Booking limit exceeded for " + empName + ". Already booked: " + countGames);
                return false;
            }
            return true;
        }

    } catch (SQLException e) {
        e.printStackTrace();
        return false; // On SQL error, deny booking
    }
}
 public static boolean addHoliday(Date date) {
        String sql = "INSERT INTO holidays (day_date) VALUES (?) ON CONFLICT DO NOTHING";
        try (Connection conn = DataBase.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, (java.sql.Date) date);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Get all holiday dates as a list of strings (yyyy-MM-dd)
public static List<String> getDisabledDaysBeforeHolidays() {
    List<String> disabledDays = new ArrayList<>();
    String sql = "SELECT day_date FROM holidays";

    try (Connection conn = DataBase.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            Date holidayDate = rs.getDate("day_date");
            // Use toLocalDate() instead of toInstant()
            LocalDate localHoliday = ((java.sql.Date) holidayDate).toLocalDate();
            LocalDate dayBefore = localHoliday.minusDays(1);

            disabledDays.add(dayBefore.format(DateTimeFormatter.ISO_LOCAL_DATE));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return disabledDays;
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

