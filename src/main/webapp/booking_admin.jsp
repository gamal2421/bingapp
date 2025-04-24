<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Booking</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
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
  transform: scale(1.1); /* Slightly enlarge on hover */
  background: rgba(255, 255, 255, 0.2);
  color: #ffffff;
}



.main-section {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  padding: 30px;
}

.form-area {
  flex: 1;
  padding-right: 30px;
}

h2 {
  font-size: 30px;
  margin-bottom: 20px;
  color: #056605;
  margin-top: 0%;
  margin-left: 20px;
}

label {
  display: block;
  margin-top: 15px;
  color: #056605; /* Green color for labels */
}

select,
input[type="date"],
input[type="text"] {
  width: 100%;
  padding: 10px;
  border: 1px solid #aaa;
  border-radius: 5px;
  font-size: 16px;
  margin-top: 5px;
  transition: all 0.3s ease-in-out; /* Smooth transition */
}

.btn-book {
  background-color: #056605;
  color: white;
  border: none;
  margin: 25%;
  margin-top: 20px;
  padding: 10px 20px;
  font-size: 15px;
  font-weight: bold;
  border-radius: 8px;
  cursor: pointer;
  width: 50%;
  box-shadow: 0 6px 12px rgba(5, 102, 5, 0.5);
  text-transform: uppercase;
  letter-spacing: 1px;
  transition: all 0.3s ease;
}

.btn-book:hover {
  background-color: #044d04;
  transform: scale(1.05); /* Slightly enlarge button on hover */
  box-shadow: 0 8px 16px rgba(5, 102, 5, 0.7);
}

.btn-book:active {
  background-color: #032f02;
  transform: scale(1);
  box-shadow: 0 6px 12px rgba(5, 102, 5, 0.5);
}

.opponent-scroll,
.time-slot-scroll {
  max-height: 200px;
  overflow-y: auto;
  border: 1px solid #056605; /* Green border for the scroll */
  padding: 10px;
  border-radius: 5px;
  margin-top: 5px;
  transition: transform 0.2s ease, opacity 0.2s ease;
}

/* Custom Scrollbar Styling */
.opponent-scroll::-webkit-scrollbar,
.time-slot-scroll::-webkit-scrollbar {
  width: 12px;
}

.opponent-scroll::-webkit-scrollbar-thumb,
.time-slot-scroll::-webkit-scrollbar-thumb {
  background-color: #056605;
  border-radius: 6px;
  border: 3px solid #ffffff; /* Adds separation between thumb and track */
}

.opponent-scroll::-webkit-scrollbar-track,
.time-slot-scroll::-webkit-scrollbar-track {
  background-color: #f1f1f1;
  border-radius: 6px;
}

#opponentList {
  height: 500px;
  overflow: hidden; /* Prevents content overflow */
  flex-grow: 1; /* Ensure it grows properly in the flex container */
}

.opponent-checkbox:hover {
  background-color: #f0f9f2;
  border-radius: 5px;
  padding-left: 5px;
  transition: background-color 0.3s ease;
}

input[type="checkbox"] {
  accent-color: #056605;
}

input[type="checkbox"]:focus {
  outline: 2px solid #056605;
  outline-offset: 2px;
}

.horizontal-group {
  display: flex;
  justify-content: space-between;
  gap: 30px;
  margin-bottom: 15px;
}

.form-group {
  flex: 1;
  margin-right: 10px;
}

.form-group.date-group input[type="text"] {
  width: 98%;
}

.form-group select {
  width: 100%;
}

.opponent-container {
  display: flex;
  justify-content: space-between;
  gap: 20px;
}

.opponent-container .time-slot-scroll,
.opponent-container .opponent-scroll {
  flex: 1 48%;
}

@media (max-width: 768px) {
  .main-section {
    flex-direction: column;
    padding: 20px;
  }

  .horizontal-group .form-group {
    flex: 1 1 100%;
  }

  .opponent-container .time-slot-scroll,
  .opponent-container .opponent-scroll {
    flex: 1 1 100%;
  }
}

.booking-fields-container {
  background: white;
  padding: 25px;
  border-radius: 15px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
  margin-bottom: 30px;
  transition: box-shadow 0.3s ease;
  margin-left: 20px;
}

.booking-fields-container:hover {
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.12);
}

.input-with-icon {
  position: relative;
  animation: slideIn 0.5s ease-out;
}

@keyframes slideIn {
  0% {
    opacity: 0;
    transform: translateX(-20px);
  }
  100% {
    opacity: 1;
    transform: translateX(0);
  }
}

.calendar-icon {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  font-size: 20px;
  color: #056605;
}

.booking-fields-container {
  animation: fadeIn 1s ease-out;
}

@keyframes fadeIn {
  0% {
    opacity: 0;
    transform: translateY(20px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

/* For Time Slots */

/* For Search Opponent */

input[type="checkbox"] {
  accent-color: #056605; 
}

.opponent-checkbox {
  color: #056605; 
}

.opponent-checkbox:hover {
  border-radius: 5px;
  padding-left: 5px;
  transition: background-color 0.3s ease;
}

.opponent-scroll {
  border: 1px solid #2e7d32;
}

/* Focused (clicked) */
input[type="text"] {
  border-color: #2e7d32;
  outline: none;
}

.green-player {
  color: #056605; /* Green color for the players' names in Double */
}

/* Green border for all select and input elements */
select {
  border: 1px solid #056605 !important;
  border-radius: 6px;
  padding: 6px;
  background-color: white;
  color: black;
  height: 40px;
}

select:focus,
select:active {
  outline: none;
  border: 1px solid #056605 !important;

  height: 40px;
}

#searchOpponent {
  width: 97%; /* Adjust the width to your desired value */
  max-width: 5; /* Set a max-width if you want to limit how wide it can be */
  padding: 8px; /* Add some padding for better spacing */
  border: 1px solid #056605; /* Maintain the green border */
  border-radius: 5px; /* Rounded corners */
}
.scrollable-select {
  height: 100px;
  overflow-y: auto; /* Ensure scrolling */
  border: 1px solid #056605; /* Green border */

  color: #056605; /* Green text color */
}

/* Scrollbar Thumb */
.scrollable-select::-webkit-scrollbar-thumb {
  background-color: #056605;
  border-radius: 6px;
  border: 3px solid #ffffff; /* Adds separation between thumb and track */
}

/* Scrollbar Track */
.scrollable-select::-webkit-scrollbar-track {
  background-color: #f1f1f1;
  border-radius: 6px;
}

/* Scrollbar itself */
.scrollable-select::-webkit-scrollbar {
  width: 10px;
  height: 10px;
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
<div class="line"></div>

<div class="main-section">
  <div class="form-area">
    <h2>Booking</h2>
    <form id="bookingForm" action="ConfirmBookingServlet" method="post" onsubmit="return validateForm()">
      <div class="booking-fields-container">
        <div class="horizontal-group">
          <div class="form-group date-group">
            <label for="date">Date</label>
            <div class="input-with-icon">
              <input type="text" id="date" name="date" required readonly>
              <span class="calendar-icon" onclick="triggerCalendar()">📅</span>
            </div>
          </div>
          
          
          <div class="form-group">
            <label for="type">Game Type</label>
            <select id="type" name="type" onchange="updateOpponentSelect()" required>
              <option value="Double">Double</option>
              <option value="Squad">Squad</option>
            </select>
          </div>
        </div>

        <div class="opponent-container">
          <div class="time-slot-scroll">
            <label  for="timeSlots" class="time-slot-label">Select Time Slots (max 5)</label>
            <div>
              <% 
                String[] times = {"10:00 AM","11:00 AM","12:00 PM","1:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM","6:00 PM","7:00 PM"};
                for(String t : times){
              %>
              <label><input type="checkbox" name="timeSlots" value="<%=t%>" onchange="checkTimeSlotLimit()"> <%=t%></label><br>
              <% } %>
            </div>
          </div>
        
          <div class="opponent-scroll" id="opponentContainer">
            <label for="searchOpponent" class="search-opponent-label">Search Opponent</label>
            <input type="text" id="searchOpponent" placeholder="Search opponent..." onkeyup="filterOpponents()">
            <div  id="opponentList"></div>
          </div>
        </div>
        
      </div>
      <button type="submit" class="btn-book">Confirm Booking</button>
    </form>
  </div>
</div>

<script>
  const players = ["Player A", "Player B", "Player C", "Player D", "Player E", "Player F", "Player G", "Player H"];
  let opponentType = "Squad";

  flatpickr("#date", {
    minDate: new Date(),
    maxDate: new Date(new Date().setDate(new Date().getDate() + 7)),
    dateFormat: "Y-m-d",
    disable: [
      function(date) {
        return date.getDay() === 5 || date.getDay() === 6;
      }
    ],
    onChange: function(selectedDates, dateStr, instance) {
      const selectedDate = selectedDates[0];
      const day = selectedDate.getDay();
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      if (selectedDate < today) {
        alert("Cannot select a past date.");
        instance.clear();
      } else if (day === 5 || day === 6) {
        alert("Booking not allowed on Fridays or Saturdays.");
        instance.clear();
      }
    }
  });

  function updateOpponentSelect() {
  const type = document.getElementById("type").value;
  opponentType = type;
  const container = document.getElementById("opponentList");
  const selectElements = document.querySelectorAll('select');
  
  // Add green border to all select elements
  selectElements.forEach(select => select.classList.add('green-border'));

  container.innerHTML = "";

  if (type === "Double") {
    const select = document.createElement("select");
    select.name = "opponent";
    select.required = true;
    select.size = 5;
    select.classList.add("scrollable-select", 'green-border');  // Add the green-border class

    players.forEach(player => {
      const option = document.createElement("option");
      option.value = player;
      option.textContent = player;
      option.classList.add("green-player");  // Add the green-player class
      select.appendChild(option);
    });

    container.appendChild(select);
  } else {
    players.forEach(player => {
      const label = document.createElement("label");
      label.classList.add("opponent-checkbox");
      label.setAttribute("data-name", player.toLowerCase());

      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.name = "opponents";
      checkbox.value = player;

      checkbox.addEventListener("change", function () {
        const checked = container.querySelectorAll("input[name='opponents']:checked");
        if (checked.length > 3) {
          this.checked = false;
          alert("Select up to 3 partners only.");
        }
      });

      label.appendChild(checkbox);
      label.append(" " + player);
      container.appendChild(label);
    });
  }
}

function filterOpponents() {
  const query = document.getElementById("searchOpponent").value.toLowerCase();
  const container = document.getElementById("opponentList");
  container.innerHTML = "";

  const filtered = players.filter(player => player.toLowerCase().includes(query));

  if (opponentType === "Double") { // ✅ Fix here
    const select = document.createElement("select");
    select.name = "opponent";
    select.required = true;
    select.size = 5;
    select.classList.add("scrollable-select", 'green-border'); // Add green-border class

    filtered.forEach(player => {
      const option = document.createElement("option");
      option.value = player;
      option.textContent = player;
      select.appendChild(option);
    });

    container.appendChild(select);
  } else {
    filtered.forEach(player => {
      const label = document.createElement("label");
      label.classList.add("opponent-checkbox");
      label.setAttribute("data-name", player.toLowerCase());

      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.name = "opponents";
      checkbox.value = player;

      checkbox.addEventListener("change", function () {
        const checked = container.querySelectorAll("input[name='opponents']:checked");
        if (checked.length > 3) {
          this.checked = false;
          alert("Select up to 3 partners only.");
        }
      });

      label.appendChild(checkbox);
      label.append(" " + player);
      container.appendChild(label);
    });
  }
}




  function filterOpponents() {
  const query = document.getElementById("searchOpponent").value.toLowerCase();
  const container = document.getElementById("opponentList");
  container.innerHTML = "";

  const filtered = players.filter(player => player.toLowerCase().includes(query));

  if (opponentType === "Double") { // ✅ Fix here
    const select = document.createElement("select");
    select.name = "opponent";
    select.required = true;
    select.size = 5;
    select.classList.add("scrollable-select");

    filtered.forEach(player => {
      const option = document.createElement("option");
      option.value = player;
      option.textContent = player;
      select.appendChild(option);
    });

    container.appendChild(select);
  } else {
    filtered.forEach(player => {
      const label = document.createElement("label");
      label.classList.add("opponent-checkbox");
      label.setAttribute("data-name", player.toLowerCase());

      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.name = "opponents";
      checkbox.value = player;

      checkbox.addEventListener("change", function () {
        const checked = container.querySelectorAll("input[name='opponents']:checked");
        if (checked.length > 3) {
          this.checked = false;
          alert("Select up to 3 partners only.");
        }
      });

      label.appendChild(checkbox);
      label.append(" " + player);
      container.appendChild(label);
    });
  }
}

  function checkTimeSlotLimit() {
    const checked = document.querySelectorAll("input[name='timeSlots']:checked");
    if (checked.length > 5) {
      alert("You can select up to 5 time slots only.");
      event.target.checked = false;
    }
  }



  function validateForm() {
  const type = document.getElementById("type").value;
  const date = document.getElementById("date").value;
  const selectedTimeSlots = document.querySelectorAll("input[name='timeSlots']:checked");

  if (!date) {
    alert("Please select a date.");
    return false;
  }

  if (selectedTimeSlots.length === 0) {
    alert("Please select at least one time slot.");
    return false;
  }

  if (type === "Squad") {
    const selectedOpponents = document.querySelectorAll("input[name='opponents']:checked");
    if (selectedOpponents.length !== 3) {
      alert("In Squad, you must select exactly 3 partners.");
      return false;
    }
  }

  return true;
}
function triggerCalendar() {
  document.getElementById("date")._flatpickr.open();
}




  // Initialize opponent list on load
  window.onload = updateOpponentSelect;
</script>

</body>
</html>
