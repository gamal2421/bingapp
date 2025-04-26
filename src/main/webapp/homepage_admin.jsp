<%@ page import="java.util.*, java.text.SimpleDateFormat" %>

<%@ page import="mypackage.models.User" %>
<%@ page import="mypackage.utl.DataBase" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Book Your Game</title>
      <link rel="stylesheet" href="styles\homepage_admin.css">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    
</head>
<body>

<nav class="navbar">
    <div class="logo">KTG</div>
    <div class="nav-links">
        <a href="homepage_user.jsp">Home</a>
        <a href="booking_user.jsp">Book</a>
        <a href="profile_user.jsp">Profile</a>
        <a href="report.jsp">Report</a>
    </div>
</nav>

<div class="line"></div>

<div class="main-wrapper">
    <div class="slots-card">
        <h2>Available Slots</h2>
        <div class="scroll-table">
            <table>
                <tr><th>Date</th><th>Time Slot</th></tr>
                <%
                    java.util.Date currentDate = new java.util.Date();
                    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd");
                    String todayFormatted = dateFormat.format(currentDate);
                    
                    List<String[]> availableSlots = User.seeAvailableSlots(currentDate);
                    if (availableSlots != null && !availableSlots.isEmpty()) {
                        for (String[] slot : availableSlots) {
                %>
                            <tr>
                                <td><%= todayFormatted %></td>
                                <td><%= slot[0] %> - <%= slot[1] %></td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr><td colspan="2">No available slots today.</td></tr>
                <%
                    }
                %>
            </table>
        </div>
        <form action="booking_user.jsp" method="get">
            <button type="submit" class="book-btn">Book Now</button>
        </form>
    </div>
</div>

</body>
</html>
