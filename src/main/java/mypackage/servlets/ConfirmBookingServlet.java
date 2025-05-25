package mypackage.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import mypackage.models.User;
import mypackage.utl.DataBase;

@WebServlet("/ConfirmBookingServlet")
public class ConfirmBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dateStr = request.getParameter("date1");
        String gameType = request.getParameter("type");
        String[] timeSlots = request.getParameterValues("timeSlots");
        String[] opponentNames;

        if ("Double".equals(gameType)) {
            opponentNames = new String[]{request.getParameter("opponent")};
        } else if ("Squad".equals(gameType)) {
            opponentNames = request.getParameterValues("opponents");
        } else {
            // Invalid game type
            response.sendRedirect("error.jsp"); // Redirect to an error page
            return;
        }

        if (timeSlots == null || timeSlots.length == 0 || opponentNames == null || opponentNames.length == 0) {
            // No time slots or opponents selected
            response.sendRedirect("error.jsp"); // Redirect to an error page
            return;
        }

        // Get admin's user ID from session
        HttpSession session = request.getSession();
        Integer adminUserId = (Integer) session.getAttribute("userId"); // Assuming user ID is stored as "userId"

        if (adminUserId == null) {
            // User not logged in or session expired
            response.sendRedirect("login.jsp"); // Redirect to login page
            return;
        }

        List<Integer> opponentEmpIds = new ArrayList<>();
        for (String opponentName : opponentNames) {
            int empId = User.getEmployeeIdByName(opponentName);
            if (empId != -1) {
                opponentEmpIds.add(empId);
            } else {
                // Opponent not found, handle error (e.g., log, redirect)
                System.err.println("Opponent not found: " + opponentName);
                // Depending on requirements, you might want to stop the booking or log and continue
                // For now, let's assume all selected opponents must be found
                response.sendRedirect("error.jsp"); // Redirect to an error page
                return;
            }
        }

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date gameDate = null;
        try {
            java.util.Date utilDate = formatter.parse(dateStr);
            gameDate = new Date(utilDate.getTime());
        } catch (ParseException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Redirect to an error page
            return;
        }

        Connection conn = null;
        try {
            conn = DataBase.getConnection();
            conn.setAutoCommit(false); // Start transaction

            String bookingGameSql = "INSERT INTO booking_game (game_date, game_type, status, slot_id) VALUES (?, ?, ?, ?)";
            String empBookingSql = "INSERT INTO Emp_booking (emp_id, book_id) VALUES (?, ?)";

            for (String slotIdStr : timeSlots) {
                int slotId = Integer.parseInt(slotIdStr);

                // Insert into booking_game
                try (PreparedStatement bookingStmt = conn.prepareStatement(bookingGameSql, Statement.RETURN_GENERATED_KEYS)) {
                    bookingStmt.setDate(1, gameDate);
                    bookingStmt.setString(2, gameType);
                    bookingStmt.setString(3, "pending"); // Assuming status is pending initially
                    bookingStmt.setInt(4, slotId);
                    bookingStmt.executeUpdate();

                    ResultSet generatedKeys = bookingStmt.getGeneratedKeys();
                    int bookingId = -1;
                    if (generatedKeys.next()) {
                        bookingId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating booking_game failed, no generated key obtained.");
                    }

                    // Insert into emp_booking for the admin
                    try (PreparedStatement empBookingStmt = conn.prepareStatement(empBookingSql)) {
                        empBookingStmt.setInt(1, adminUserId);
                        empBookingStmt.setInt(2, bookingId);
                        empBookingStmt.executeUpdate();
                    }

                    // Insert into emp_booking for each opponent
                    for (int opponentEmpId : opponentEmpIds) {
                        try (PreparedStatement empBookingStmt = conn.prepareStatement(empBookingSql)) {
                            empBookingStmt.setInt(1, opponentEmpId);
                            empBookingStmt.setInt(2, bookingId);
                            empBookingStmt.executeUpdate();
                        }
                    }
                }
            }

            conn.commit(); // Commit transaction
            response.sendRedirect("homepage_admin.jsp"); // Redirect to a success page

        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback transaction on error
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Redirect to an error page
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Restore auto-commit
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
} 