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
<style>
body {
  font-family: 'Poppins', sans-serif;
  margin: 0;
  background: linear-gradient(to bottom right, #e8f5e9, #ffffff);
}
.big {
  background-image: url("homepage_photo.png");
  background-repeat: no-repeat;
  background-size: cover;
}

.navbar {
    background: linear-gradient(to right,rgb(133, 216, 137), #1b5e20);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 40px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}
.logo {
  font-size: 28px;
  color: #ffffff;
  font-weight: 700;
  letter-spacing: 2px;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 25px;
}

.nav-links a {
  text-decoration: none;
  color: #e0f2f1;
  font-weight: 500;
  padding: 10px 20px;
  font-size: 17px;
  border-radius: 8px;
  transition: background 0.3s ease, color 0.3s ease, transform 0.3s ease;
}

.nav-links a:hover {
  transform: scale(1.1);
  background: rgba(255, 255, 255, 0.2);
  color: #ffffff;
}

.profile-card {
  width: 300px;
  max-width: 100%;
  margin: 0 auto;
  margin-top: 30px;
 
  margin-left: 50px;
}

@keyframes fadeInProfile {
  0% { opacity: 0; }
  100% { opacity: 1; }
}

#view-mode {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
}

.profile-card .avatar {
  width: 90px;
  height: 90px;
}

.profile-card .avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 10px;
  animation: popIn 0.6s ease-out forwards;
}

@keyframes popIn {
  0% {
    transform: scale(0.6);
    opacity: 0;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.profile-card .info {
  display: flex;
  flex-direction: column;
  justify-content: center;
  flex-grow: 1;
  gap: 5px;
}

.profile-card h3 {
  font-size: 24px;
  color: #056605;
  margin: 0;
}

.profile-card p {
  font-size: 16px;
  color: #777;
}

.edit-icon {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #056605;
  margin-left: auto;
  transition: transform 0.3s ease;
}

.edit-icon:hover {
  color: #2e7d32;
  transform: scale(1.2);
}

.modal {
  display: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  justify-content: center;
  align-items: center;
  opacity: 0;
  transform: scale(0.95);
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.modal.show {
  opacity: 1;
  transform: scale(1);
}

.modal-content {
  background-color: white;
  padding: 30px;
  border-radius: 12px;
  width: 340px;
  position: relative;
}

.modal-content h2 {
  margin-top: 0;
  color: #056605;
}

.modal-content input {
  width: 100%;
  padding: 10px;
  margin: 12px 0;
  border: 1px solid #ccc;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.modal-content input:focus {
  outline: none;
  border-color: #66bb6a;
  box-shadow: 0 0 5px rgba(102, 187, 106, 0.5);
}

.modal-buttons {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.modal-buttons button {
  padding: 8px 16px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
}

.save {
  background-color: #388e3c;
  color: white;
}

.cancel {
  background-color: #ccc;
}

.close-btn {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 20px;
  cursor: pointer;
  color: #aaa;
}

.slots-card {
  width: 90%;
  max-width: 700px;
  margin: 0 auto;
  height: auto;
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

.slots-card h2 {
  font-size: 28px;
  font-weight: 600;
  color: #1b5e20;
  margin-bottom: 20px;
}

.scroll-table {
  max-height: 300px;
  overflow-y: auto;
  border-radius: 10px;
  border: 1px solid #ddd;
}

.scroll-table table {
  width: 100%;
  border-collapse: collapse;
}

.scroll-table th,
.scroll-table td {
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  font-size: 16px;
}

.scroll-table th {
  background-color: #2e7d32;
  color: white;
}

.scroll-table tr {
  opacity: 0;
  transform: translateY(20px);
  animation: slideFadeIn 0.4s ease forwards;
}

.scroll-table tr:nth-child(even) {
  animation-delay: 0.2s;
}

.scroll-table tr:nth-child(odd) {
  animation-delay: 0.1s;
}

@keyframes slideFadeIn {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.scroll-table::-webkit-scrollbar {
  width: 8px;
}

.scroll-table::-webkit-scrollbar-thumb {
  background-color: #a5d6a7;
  border-radius: 8px;
}

.profile-slots-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
  padding: 30px;
}

@media (max-width: 768px) {
  .navbar {
    flex-direction: column;
    align-items: flex-start;
    padding: 15px;
  }

  .profile-card,
  .slots-card {
    width: 100%;
  }

  .profile-slots-container {
    flex-direction: column;
    align-items: center;
  }
}

.delete-icon-btn {
  background-color: #2e7d32;
  border: none;
  border-radius: 50%;
  padding: 8px;
  cursor: pointer;
  transition: background 0.3s ease;
}

.delete-icon-btn i {
  color: white;
  font-size: 16px;
}

.delete-icon-btn:hover {
  background-color: #1b5e20;
}

.delete-icon-btn:focus {
  outline: none;
  box-shadow: 0 0 5px rgba(46, 125, 50, 0.5);
}

.delete-icon-btn:active {
  transform: scale(0.95);
}



</style>
<body>
  <div class="navbar">
   <img style="width:100px" src="logo.png" alt="Logo" class="logo">
    <div class="nav-links">
      <a href="homepage_user.jsp">Home</a>
      <a href="booking_user.jsp">Book</a>
      <a href="profile_user.jsp">Profile</a>
   

    </div>
  </div>
  <div class= "big">

 

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
