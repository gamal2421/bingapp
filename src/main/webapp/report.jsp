<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, java.text.*, mypackage.models.Admin" %> 

<html>
<head>
    <title>Report</title>
    <link rel="stylesheet" href="styles/report.css">
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
        <label for="date">Date:</label>
        <input type="date" id="date" name="date" />
        <button type="submit">Search</button>
    </form>

    <div class="slots-card">
        <div class="scroll-table">
            <table>
                <thead>
                    <tr><th>Time Slots</th><th>Players</th></tr>
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
                    %>
                                    <tr>
                                        <td><%= slotTime %></td>
                                        <td><%= (players != null ? players : "No players booked") %></td>
                                    </tr>
                    <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                    %>
                                <tr><td colspan="2">Error loading report.</td></tr>
                    <%
                            }
                        } else {
                    %>
                        <tr><td colspan="2">Please select a date to view report.</td></tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
