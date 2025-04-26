package mypackage.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/GetAvailableSlotsServlet") // <<< Correct mapping to match fetch
public class GetAvailableSlotsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dateStr = request.getParameter("date1");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (dateStr != null && !dateStr.isEmpty()) {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            try {
                java.util.Date selectedDate = formatter.parse(dateStr);

                List<String[]> slots = mypackage.models.User.seeAvailableSlots(selectedDate); // your DB call

                for (String[] slot : slots) {
                    String timeDisplay = slot[0] + " - " + slot[1];
                    out.println("<div><input type='checkbox' name='timeSlots' onchange='checkTimeSlotLimit()' value='" + timeDisplay + "'> " + timeDisplay + "</div>");
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
