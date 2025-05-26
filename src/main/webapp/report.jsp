<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, java.text.*, mypackage.models.Admin , mypackage.models.User, mypackage.models.Booking" %> 

<%
    request.setCharacterEncoding("UTF-8");

    // Only process deletion on POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String deleteBookingIdStr = request.getParameter("deleteBookingId");
        if (deleteBookingIdStr != null) {
            try {
                int bookingId = Integer.parseInt(deleteBookingIdStr);
                Integer currentUserId = (Integer) session.getAttribute("userId");
                if (currentUserId != null) {
                    User userForDeletion = new User();
                    userForDeletion.cancelBooking(bookingId);

                    // Redirect to the same report page preserving the date filter if present
                   String dateParam = request.getParameter("date");
                   String nameParam = request.getParameter("name");

                    if (dateParam != null && !dateParam.isEmpty()) {
                        response.sendRedirect("report.jsp?date=" + dateParam);
                    } else {
                        response.sendRedirect("report.jsp");
                    }
                    return; // Important: stop further processing after redirect
                } else {
                    out.println("User not logged in.");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                out.println("Invalid booking ID.");
            }
        }
    }
%>

<html>
<head>
    <title>Report</title>
    <link rel="stylesheet" href="styles/report.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <div class="navbar">
        <div class="logo">KTG</div>
        <div class="nav-links">
            <a href="homepage_admin.jsp">Home</a>
            <a href="booking_admin.jsp">Book</a>
            <a href="profile_admin.jsp">Profile</a>
            <a href="report.jsp">Report</a>
        </div>
    </div>

    <div class="line"></div>

    <h2>Report</h2>

    <form method="get" action="report.jsp">
     <label for="name">Player Name:</label>
    <input type="text" id="name" name="name" 
           value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>" />
        <label for="date">Date:</label>
        <input type="date" id="date" name="date" />
        <button type="submit">Search</button>
    </form>

    <div class="slots-card">
        <div class="scroll-table">
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Players</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    String dateParam = request.getParameter("date");
                    if (dateParam != null && !dateParam.isEmpty()) {
                        try {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            java.util.Date parsedDate = sdf.parse(dateParam);
                            java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());

                            List<Map<String, String>> reportData = Admin.viewReport(sqlDate);
                            for (Map<String, String> record : reportData) {
                                String slotTime = record.get("slot_time");
                                String players = record.get("players");
                                String status = record.get("status");
                %>
                    <tr>
                        <td><%= slotTime %></td>
                        <td><%= (players != null ? players : "No players booked") %></td>
                        <td><%= (status != null ? status : "Unknown") %></td>
                      <td>
<%
    String bookingId = record.get("booking_id");
    if ("Pending".equalsIgnoreCase(status) && bookingId != null) {
%>
    <form method="post" action="report.jsp" style="display:inline;">
    <input type="hidden" name="deleteBookingId" value="<%= bookingId %>" />
    <%-- Pass the current date parameter if filtering is active --%>
    <input type="hidden" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>" />
    <button type="submit" class="delete-icon-btn" onclick="return confirm('Are you sure you want to delete this booking?')">
        <i class="fas fa-trash"></i>
    </button>
</form>
<%
    } else {
%>
    &mdash;  <!-- or empty if you want -->
<%
    }
%>
</td>
                    </tr>
                <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                %>
                    <tr><td colspan="4">Error loading report.</td></tr>
                <%
                        }
                    } else {
                %>
                    <tr><td colspan="4">Please select a date to view report.</td></tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
