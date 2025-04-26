<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Booking</title>
  <link rel="stylesheet" href="styles/booking_admin.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
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
