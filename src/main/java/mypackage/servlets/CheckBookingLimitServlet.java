package mypackage.servlets;

import java.io.IOException;
import java.util.Date;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mypackage.models.User;

@WebServlet("/CheckBookingLimitServlet")
public class CheckBookingLimitServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String empName = request.getParameter("empName");
        String dateStr = request.getParameter("date1");
        String slotsStr = request.getParameter("numSlots");

        System.out.println("empName: " + empName); // ADD LOGS
        System.out.println("dateStr: " + dateStr);
        System.out.println("slotsStr: " + slotsStr);
        try {
            Date gameDate = java.sql.Date.valueOf(dateStr);
            int numSlots = Integer.parseInt(slotsStr);

            boolean canBook = User.canEmployeeBookSlots(empName, gameDate, numSlots);
            response.setContentType("text/plain");
            response.getWriter().write(String.valueOf(canBook));

        } catch (Exception e) {
            response.setContentType("text/plain");
            response.getWriter().write("false");
        }
    }
}
