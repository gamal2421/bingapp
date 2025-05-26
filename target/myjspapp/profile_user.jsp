<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="mypackage.models.User" %>
<%@ page import="mypackage.models.Booking" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="mypackage.utl.DataBase" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>

<%
    request.setCharacterEncoding("UTF-8"); // just in case

    String deleteBookingIdStr = request.getParameter("deleteBookingId");
    if (deleteBookingIdStr != null) {
        try {
            int bookingId = Integer.parseInt(deleteBookingIdStr);

            Integer currentUserId = (Integer) session.getAttribute("userId");
            if (currentUserId != null) {
                // Create User object (even with dummy data, because we only need the method)
                User userForDeletion = new User();
                userForDeletion.cancelBooking(bookingId);
                
                // Optional: Refresh the page after deletion
                response.sendRedirect("profile_user.jsp");
                return;
            } else {
                out.println("User not logged in.");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            out.println("Invalid booking ID.");
        }
    }
%>


<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile & Available Slots</title>
  <link rel="stylesheet" href="styles\profile_user.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>
  <div class="navbar">
    <div class="logo">KTG</div>
    <div class="nav-links">
      <a href="homepage_user.jsp">Home</a>
      <a href="booking_user.jsp">Book</a>
      <a href="profile_user.jsp">Profile</a>
   

    </div>
  </div>
  <div class= "big">

  <div class="profile-slots-container"> 
    <div class="profile-card">
        <div id="view-mode">
            <div class="avatar">
                <img src="uploads/<%= session.getAttribute("avatar") != null ? session.getAttribute("avatar") : "avatar.jpeg" %>" alt="Profile" />
            </div>
            <div class="info">
                <h3><%= session.getAttribute("username") != null ? session.getAttribute("username") : "NO User Name" %></h3>
                <p><%= session.getAttribute("email") != null ? session.getAttribute("email") : "No Email" %></p>
            </div>
            <button class="edit-icon" onclick="openEditModal()">✎</button>
        </div>
    </div>

    <%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        out.println("User not logged in.");
        return;
    }

    String firstName = "firstName";  // Fetch from DB based on userId
    String lastName = "lastName";    
    String gender = "gender";     
    Date dob = new Date();      

    User user = new User(userId, firstName, lastName, gender, dob);
    List<Booking> bookedSlots = user.showBookedSlots(userId);
    %>

    <div class="slots-card">
    <h2>Upcoming Bookings</h2>
    <div class="scroll-table">
        <table>
            <tr>
                <th>Date</th>
                <th>Start time</th>
                <th>End time</th>
                <th>Game type</th>
                 <th>Status</th>
                 <th>Action</th>
                 <!-- New column for delete button -->
            </tr>
            <% for (Booking booking : bookedSlots) { 
                java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMMM dd, yyyy");
                String formattedDate = dateFormat.format(booking.getGameDate());
            %>
            <tr>
                <td><%= formattedDate %></td>
                <td><%= booking.getStartTime() %></td>
                <td><%= booking.getEndTime() %></td>
                <td><%= booking.getGameType() %></td>
                <td><%= booking.getStatus() %></td>
<td>
    <% if ("Pending".equalsIgnoreCase(booking.getStatus())) { %>
        <form method="post" action="profile_user.jsp" style="display:inline;">
            <input type="hidden" name="deleteBookingId" value="<%= booking.getBookingId() %>">
            <button type="submit" class="delete-icon-btn" onclick="return confirm('Are you sure you want to delete this booking?')">
                <i class="fas fa-trash"></i>
            </button>
        </form>
    <% } %>
</td>


            </tr>
            <% } %>
        </table>
    </div>
</div>

  </div>

<div class="modal" id="editModal">
  <div class="modal-content">
      <span class="close-btn" onclick="closeModal()">×</span>
      <h2>Edit Profile</h2>
<form method="post" action="profile_user.jsp" enctype="multipart/form-data">
    <input type="file" name="avatar" accept="image/*">

    <input 
      type="text" 
      name="username" 
      value="<%= session.getAttribute("username") != null ? session.getAttribute("username") : "NO User Name" %>" 
      required
    >

    <input 
      type="email" 
      name="email" 
      value="<%= session.getAttribute("email") != null ? session.getAttribute("email") : "No Email" %>" 
      readonly
    >

    <div class="modal-buttons">
        <button type="button" class="cancel" onclick="closeModal()">Cancel</button>
        <button type="submit" class="save">Save</button>
    </div>
</form>

  </div>
</div>
</div>

  <script>
    const modal = document.getElementById("editModal");
  
    function openModal() {
      modal.style.display = "flex";
      requestAnimationFrame(() => {
        modal.classList.add("show");
      });
    }
  
    function closeModal() {
      modal.classList.remove("show");
      setTimeout(() => {
        modal.style.display = "none";
      }, 300);
    }
  
    // This is where you call the function on the button click
    document.querySelector(".edit-icon").addEventListener("click", openModal);
  </script>
  
</body>
</html>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        Part avatarPart = request.getPart("avatar");
        String avatarFileName = null;

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String uploadPath = application.getRealPath("/") + "uploads/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            avatarFileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
            File file = new File(uploadPath + avatarFileName);
            avatarPart.write(file.getAbsolutePath());
        }

        session.setAttribute("username", username);
        session.setAttribute("email", email);
        if (avatarFileName != null) {
            session.setAttribute("avatar", avatarFileName);
        }

        response.sendRedirect("profile_user.jsp");
    }
%>
