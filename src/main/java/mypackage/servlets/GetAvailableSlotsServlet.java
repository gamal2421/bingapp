package mypackage.servlets;

import mypackage.models.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/GetAvailableSlotsServlet")
public class GetAvailableSlotsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dateStr = request.getParameter("date1");
        String gender = request.getParameter("gender");  // <<<< get gender

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve logged-in user from session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser"); 
        String season = user.getSeason();

        if (dateStr != null && !dateStr.isEmpty()) {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            try {
                java.util.Date selectedDate = formatter.parse(dateStr);

                List<String[]> slots;

                if ("Male".equalsIgnoreCase(gender)) {
                    if ("Ramadan".equalsIgnoreCase(season)) {
                        slots = User.seeRamadanAvailableSlots(selectedDate);
                    } else {
                        slots = User.seeAvailableSlots(selectedDate);
                    }
                } else if ("Female".equalsIgnoreCase(gender)) {
                    if ("Ramadan".equalsIgnoreCase(season)) {
                        slots = User.ramadanFemaleAvailableSlots(selectedDate);
                    } else {
                        slots = User.femaleAvailableSlots(selectedDate);
                    }
                } else {
                    out.println("<p>Invalid gender selected.</p>");
                    return;
                }

                for (String[] slot : slots) {
                    String startTime = slot[0];
                    String endTime = slot[1];
                    int slotId = Integer.parseInt(slot[2]);
                    String timeDisplay = startTime + " - " + endTime;
                    out.println("<div><input type='checkbox' name='timeSlots' onchange='checkTimeSlotLimit()' value='" + slotId + "'> " + timeDisplay + "</div>");
                }
            } catch (ParseException e) {
                e.printStackTrace();
                out.println("<p>Error parsing date.</p>");
            }
        } else {
            out.println("<p>Please pick a valid date to see available slots.</p>");
        }
    }
}
