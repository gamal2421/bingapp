<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Paths" %>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile & Available Slots</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
  <style>
body {
  font-family: 'Poppins', sans-serif;
  margin: 0;
  background: linear-gradient(to bottom right, #e8f5e9, #ffffff);
}

.navbar {
  background: linear-gradient(to right, #2e7d32, #1b5e20);
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
  background: white;
  padding: 20px;
  width: 100%;
  max-width: 500px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 390px;
  margin-top: 30px;
  margin-left: 90px;
  opacity: 0;
  animation: fadeInProfile 1s ease-in-out forwards;
}

@keyframes fadeInProfile {
  0% { opacity: 0; }
  100% { opacity: 1; }
}

.profile-card .avatar {
  width: 150px;
  height: 150px;
}
#view-mode {
  display: flex;
  align-items: center;
  gap: 20px;
}



.profile-card  .avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  animation: popIn 0.6s ease-out forwards;
  border-radius: 10px;
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
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 10px;
  padding: 20px;
  margin: 30px auto;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  width: 100%;
  max-width: 500px;
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
  justify-content: space-between;
  gap: 30px;
  flex-wrap: wrap;
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

  </style>
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

  <div class="profile-slots-container">
    <div class="profile-card">
        <div id="view-mode">
            <div class="avatar">
                <!-- Display the updated avatar or a default avatar if not available -->
                <img src="uploads/<%= session.getAttribute("avatar") != null ? session.getAttribute("avatar") : "avatar.jpeg" %>" alt="Profile" />
            </div>
<div class="info">
            <!-- Display updated username and email -->
            <h3><%= session.getAttribute("username") != null ? session.getAttribute("username") : "johndoe" %></h3>
            <p><%= session.getAttribute("email") != null ? session.getAttribute("email") : "johndoe@example.com" %></p>
        </div>
            <button class="edit-icon" onclick="openEditModal()">✎</button>
        </div>
    </div>

    <div class="slots-card">
      <h2>Upcoming Bookings</h2>
      <div class="scroll-table">
        <table>
          <tr><th>Time Slots</th><th>Plyers</th></tr>
          <tr><td>April 24</td><td>5:00 PM - 5:10 PM</td></tr>
          <tr><td>April 24</td><td>5:10 PM - 5:20 PM</td></tr>
          <tr><td>April 24</td><td>5:20 PM - 5:30 PM</td></tr>
          <tr><td>April 24</td><td>5:30 PM - 5:40 PM</td></tr>
          <tr><td>April 24</td><td>5:40 PM - 5:50 PM</td></tr>
          <tr><td>April 25</td><td>5:00 PM - 5:10 PM</td></tr>
          <tr><td>April 25</td><td>5:10 PM - 5:20 PM</td></tr>
        </table>
      </div>
    </div>
  </div>

  <div class="modal" id="editModal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeEditModal()">×</span>
        <h2>Edit Profile</h2>

        <!-- Form to handle the profile update -->
        <form method="post" action="profile_user.jsp" enctype="multipart/form-data">
            <!-- File input for the avatar -->
            <input type="file" name="avatar" accept="image/*">
            <!-- Text fields for the username and email -->
            <input type="text" name="username" value="<%= session.getAttribute("username") != null ? session.getAttribute("username") : "johndoe" %>">
            <input type="email" name="email" value="<%= session.getAttribute("email") != null ? session.getAttribute("email") : "johndoe@example.com" %>">
            <div class="modal-buttons">
                <button type="button" class="cancel" onclick="closeEditModal()">Cancel</button>
                <button type="submit" class="save">Save Changes</button>
            </div>
        </form>
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
      }, 300); // Wait for animation to finish
    }
  
    document.querySelector(".edit-icon").addEventListener("click", openModal);
  </script>
  
</body>
</html>
<%
    // Check if the form is submitted (POST request)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Get the form parameters (username and email)
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        // Handle file upload (avatar)
        Part avatarPart = request.getPart("avatar");  // Get the uploaded file
        String avatarFileName = null;

        if (avatarPart != null && avatarPart.getSize() > 0) {
            // Save the uploaded avatar file to the server
            String uploadPath = application.getRealPath("/") + "uploads/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();  // Create the directory if it doesn't exist
            }

            avatarFileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();  // Get the file name
            File file = new File(uploadPath + avatarFileName);
            avatarPart.write(file.getAbsolutePath());  // Save the file to the server
        }

        // Save the updated profile info in the session (or in a database)
        session.setAttribute("username", username);
        session.setAttribute("email", email);
        if (avatarFileName != null) {
            session.setAttribute("avatar", avatarFileName);
        }

        // Redirect to the same page to display the updated profile
        response.sendRedirect("profile_user.jsp");
    }
%>

