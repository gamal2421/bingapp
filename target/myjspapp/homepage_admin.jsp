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
<style>* {
    box-sizing: border-box;
}

body {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    padding: 0;
    background: linear-gradient(to bottom right, #e8f5e9, #ffffff);
    color: #333;
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
    transform: scale(1.1); /* Slightly enlarge on hover */
    background: rgba(255, 255, 255, 0.2);
    color: #ffffff;
  }
  
  

.line {
    height: 2px;
    background-color: #c8e6c9;
    width: 95%;
    margin: 0 auto 20px;
    border-radius: 5px;
}

.main-wrapper {
    display: flex;
    flex-direction: row;
    align-items: stretch;
    justify-content: center;
    padding: 40px;
    gap: 40px;
    flex-wrap: wrap;
    margin-top: -1px;
}

.slots-card {
    flex: 1;
    min-width: 400px;
    background-color: rgba(255, 255, 255, 0.95);
    border-radius: 16px;
    padding: 30px;
    box-shadow: 0 12px 30px rgba(0,0,0,0.1);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    height: 100%;
    animation: fadeInLeft 1s ease;
    background-image: url("homepage_photo.png");
    background-repeat: no-repeat;
    background-size: cover;
}

.slots-card h2 {
    font-size: 28px;
    font-weight: 600;
    color: #1b5e20;
    margin-bottom: 20px;
}

.scroll-table {
    max-height: 270px;
    overflow-y: auto;
    border-radius: 10px;
    border: 1px solid #ddd;
    background-color: rgba(255, 255, 255, 0.75);
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
    text-align: center; 
}

.scroll-table th {
    background-color: #2e7d32;
    color: white;
}

.book-btn {
    margin: 30px auto 0;
    background: linear-gradient(to right, #43a047, #2e7d32);
    color: white;
    padding: 15px 50px;
    font-size: 20px;
    font-weight: 600;
    border: none;
    border-radius: 50px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 6px 18px rgba(67, 160, 71, 0.4);
    display: block;
}

.book-btn:hover {
    background: linear-gradient(to right, #388e3c, #1b5e20);
    transform: scale(1.03);
    box-shadow: 0 8px 24px rgba(56, 142, 60, 0.5);
}

.image-box {
    flex: 1;
    min-width: 550px;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: fadeInRight 1s ease;
    width: 100%;
}

.image-wrapper {
    width: 100%;
    max-width: 550px;
    height: 532px;
    overflow: hidden;
    border-radius: 20px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
    transition: transform 0.4s ease;
}

.main-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.image-wrapper:hover {
    transform: scale(1.03);
}


@keyframes fadeInLeft {
    from {
        opacity: 0;
        transform: translateX(-40px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes fadeInRight {
    from {
        opacity: 0;
        transform: translateX(40px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}


.scroll-table::-webkit-scrollbar {
    width: 8px;
}

.scroll-table::-webkit-scrollbar-thumb {
    background-color: #a5d6a7;
    border-radius: 8px;
}

@media (max-width: 900px) {
    .main-wrapper {
        flex-direction: column;
        align-items: center;
    }

    .main-image {
        max-width: 90%;
    }
}
                          </style>
<body>

<nav class="navbar">
   <img style="width:100px" src="logo.png" alt="Logo" class="logo">
    <div class="nav-links">
        <a href="homepage_admin.jsp">Home</a>
        <a href="booking_admin.jsp">Book</a>
        <a href="profile_admin.jsp">Profile</a>
        <a href="manage.jsp">Manage</a>
        
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
                    
                    List<String[]> availableSlots = User.todayAvailableSlots(currentDate);
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
        <form action="booking_admin.jsp" method="get">
            <button type="submit" class="book-btn">Book Now</button>
        </form>
    </div>
</div>

</body>
</html>
