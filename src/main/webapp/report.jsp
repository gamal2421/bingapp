<%@ page contentType="text/html;charset=UTF-8" language="java" %> 

<html>
<head>
    <title>Report</title>
    <link rel="stylesheet" href="styles\report.css">
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
                    <tr><td>April 24</td><td>5:00 PM - 5:10 PM</td></tr>
                    <tr><td>April 24</td><td>5:10 PM - 5:20 PM</td></tr>
                    <tr><td>April 24</td><td>5:20 PM - 5:30 PM</td></tr>
                    <tr><td>April 24</td><td>5:30 PM - 5:40 PM</td></tr>
                    <tr><td>April 24</td><td>5:40 PM - 5:50 PM</td></tr>
                    <tr><td>April 25</td><td>5:00 PM - 5:10 PM</td></tr>
                    <tr><td>April 25</td><td>5:10 PM - 5:20 PM</td></tr>
                    <tr><td>April 25</td><td>5:20 PM - 5:30 PM</td></tr>
                    <tr><td>April 25</td><td>5:30 PM - 5:40 PM</td></tr>
                    <tr><td>April 25</td><td>5:40 PM - 5:50 PM</td></tr>
                    <tr><td>April 25</td><td>5:50 PM - 6:00 PM</td></tr>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
