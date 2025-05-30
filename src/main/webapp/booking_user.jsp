<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, mypackage.models.User" %>
<%@ page import="mypackage.utl.DataBase" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Booking</title>

  <link rel="stylesheet" href="styles/booking_user.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

  <style>
    .navbar {
      background: linear-gradient(to right,rgb(133, 216, 137), #1b5e20);
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px 40px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }
    .loading-overlay {
      position: fixed;
      top: 0; left: 0; width: 100%; height: 100%;
      background-color: rgba(255,255,255,0.7);
      display: flex; justify-content: center; align-items: center;
      z-index: 9999;
      display: none;
    }
    .spinner {
      width: 60px; height: 60px;
      border: 6px solid #ccc;
      border-top-color: #1b5e20;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    /* Additional CSS for scrollable selects, opponent checkboxes, buttons, etc. */
    .scrollable-select {
      width: 100%;
      max-height: 150px;
      overflow-y: auto;
    }
    .green-border {
      border: 2px solid #1b5e20;
      border-radius: 5px;
    }
    .btn-book {
      background-color: #1b5e20;
      color: white;
      padding: 10px 20px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-weight: 600;
      margin-top: 15px;
    }
    .btn-book:hover {
      background-color: #145214;
    }
    .opponent-checkbox {
      display: block;
      margin-bottom: 5px;
    }
    .input-with-icon {
      position: relative;
    }
    .calendar-icon {
      position: absolute;
      right: 10px;
      top: 50%;
      transform: translateY(-50%);
      cursor: pointer;
    }
  </style>
</head>
<body>

<%
  User user = (User) session.getAttribute("loggedInUser");
  String username = (String) session.getAttribute("username");

  // Prepare map from full name to gender
  List<String> allEmployees = user != null ? user.getAllEmployeeFullNames() : Collections.emptyList();
  Map<String, String> nameToGender = new HashMap<>();

  if (user != null) {
    for (String emp : allEmployees) {
      String gender = user.getGenderByFullName(emp);
      if (gender != null) {
        nameToGender.put(emp, gender);
      }
    }
  }
  // Remove logged-in user from opponent list
  if (username != null) {
    nameToGender.remove(username.trim());
  }
%>

<!-- Navbar -->
<div class="navbar">
  <img style="width:100px" src="logo.png" alt="Logo" class="logo">
  <div class="nav-links">
    <a href="homepage_user.jsp">Home</a>
    <a href="booking_user.jsp">Book</a>
    <a href="profile_user.jsp">Profile</a>
  </div>
</div>

<% if (request.getAttribute("errorMessage") != null) { %>
  <div style="color: red; font-weight: bold; padding: 10px;">
    <%= request.getAttribute("errorMessage") %>
  </div>
<% } %>

<div class="main-section">
  <div class="form-area">
    <h2>Booking</h2>
    <form id="bookingForm" action="ConfirmBookingServlet" method="post" onsubmit="return validateForm()">

      <div class="booking-fields-container">

        <div class="horizontal-group">
          <div class="form-group date-group">
            <label for="date">Date</label>
            <div class="input-with-icon">
              <input type="text" id="date" name="date1" required readonly>
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

          <div class="time-slot-scroll" id="timeSlotsContainer">
            <label>Select Time Slots (max 5)</label>
            <p>Please pick a date to see available time slots</p>
          </div>

          <div class="opponent-scroll" id="opponentContainer" style="display: none;">
            <label for="searchOpponent" class="search-opponent-label">Search Opponent</label>
            <input type="text" id="searchOpponent" placeholder="Search opponent..." onkeyup="filterOpponents()" disabled>
            <div id="opponentList"></div>
          </div>

        </div> <!-- close opponent-container -->

      </div> <!-- close booking-fields-container -->

      <button type="submit" class="btn-book">Confirm Booking</button>
    </form>
  </div> <!-- close form-area -->
</div> <!-- close main-section -->

<div id="loadingOverlay" class="loading-overlay">
  <div class="spinner"></div>
</div>

<%
  String userGender = (user != null) ? user.getGender() : "";
 
  String loggedInUserFullName = "";
  if (user != null) {
    String firstName = user.getFirstName() != null ? user.getFirstName().trim() : "";
    String lastName = user.getLastName() != null ? user.getLastName().trim() : "";
    loggedInUserFullName = firstName + " " + lastName;
  }

%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/gson/2.10.1/gson.min.js"></script>
<script>
  // Convert Java Map to JSON using Gson
  const nameToGender = <%= new com.google.gson.Gson().toJson(nameToGender) %>;
  const players = Object.keys(nameToGender);
  const gender = "<%= userGender %>";
  const loggedInUser = "<%= loggedInUserFullName %>";
  console.log("Logged in user full name:", loggedInUser);
  let opponentType = "Squad";

    // Initialize Flatpickr right after DOM is loaded
document.addEventListener("DOMContentLoaded", function () {
    const dateInput = document.getElementById("date");
    flatpickr(dateInput, {
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
});
   function updateOpponentSelect(filterGender = null) {
  const type = document.getElementById("type").value;
  opponentType = type;
  const container = document.getElementById("opponentList");

  container.innerHTML = "";

  // Filter players by gender if filterGender provided
  let filteredPlayers = players;
  if (filterGender) {
    filteredPlayers = players.filter(player => nameToGender[player] === filterGender);
  }

  if (type === "Double") {
    const select = document.createElement("select");
    select.name = "opponent";
    select.required = true;
    select.size = 5;
    select.classList.add("scrollable-select", 'green-border');

    filteredPlayers.forEach(player => {
      const option = document.createElement("option");
      option.value = player;
      option.textContent = player;
      option.classList.add("green-player");
      select.appendChild(option);
    });

    container.appendChild(select);
  } else {
    filteredPlayers.forEach(player => {
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
document.addEventListener('DOMContentLoaded', () => {
  const slotContainer = document.getElementById('timeSlotsContainer'); // or querySelector
  const opponentSearch = document.getElementById('searchOpponent');
  const opponentContainer = document.getElementById('opponentContainer');

  timeSlotsContainer.addEventListener('change', () => {
    const selectedSlots = Array.from(timeSlotsContainer.querySelectorAll("input[name='timeSlots']:checked"))
                              .map(cb => cb.value);

    if (selectedSlots.length > 0) {
      opponentSearch.disabled = false;
      opponentContainer.style.display = 'block';

      if (selectedSlots.includes("10-11")) {
        // Show only female players
        updateOpponentSelect("female");
      } else {
        // Show all players (no filter)
        updateOpponentSelect(null);
      }
    } else {
      opponentSearch.disabled = true;
      opponentContainer.style.display = 'none';
    }
  });
});





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
    // Modify your existing time slot change listener to:




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
      const selectedOpponentList = Array.from(selectedOpponents).map(cb => cb.value);
      console.log("Selected Opponents:", selectedOpponentList); // ✅ This should now show
    }

    if (type === "Double") {
      const opponentSelect = document.querySelector("select[name='opponent']");
      const selectedOpponent = opponentSelect?.value || null;
      console.log("Selected Opponent:", selectedOpponent); // ✅ This should also show
    }

    return true;
  } 

 function triggerCalendar() {
    const dateInput = document.getElementById("date");
    // Check if Flatpickr is already initialized
    if (dateInput._flatpickr) {
        dateInput._flatpickr.open();
    } else {
        // If not initialized yet, initialize it and then open
        flatpickr(dateInput, {
            minDate: new Date(),
            maxDate: new Date(new Date().setDate(new Date().getDate() + 7),
            dateFormat: "Y-m-d",
            disable: [
                function(date) {
                    return date.getDay() === 5 || date.getDay() === 6;
                }
            ]
        }).open();
    }
}


  document.addEventListener('DOMContentLoaded', function() {
      const dateInput = document.getElementById('date');
      const genderSelect = document.getElementById('gender');

  function fetchAvailableSlots() {
      const selectedDate = dateInput.value;
      const selectedGender = gender;
  const loadingOverlay = document.getElementById('loadingOverlay');

      if (!selectedDate) return;
      loadingOverlay.style.display = 'flex';

      fetch('GetAvailableSlotsServlet', {
          method: 'POST',
          headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: 'date1=' + encodeURIComponent(selectedDate) + '&gender=' + encodeURIComponent(selectedGender)
      })
      .then(response => response.text())
      .then(data => {
          const slotContainer = document.getElementById('timeSlotsContainer');
          slotContainer.innerHTML = data;

          // Initially disable and hide opponent section
          const opponentSearch = document.getElementById('searchOpponent');
          const opponentContainer = document.getElementById('opponentContainer');
          opponentSearch.disabled = true;
          opponentContainer.style.display = 'none';

          // Attach event listeners to time slot checkboxes
          const checkboxes = slotContainer.querySelectorAll("input[name='timeSlots']");
          checkboxes.forEach(cb => {
              cb.addEventListener('change', () => {
                  const selected = slotContainer.querySelectorAll("input[name='timeSlots']:checked");
                  if (selected.length > 0) {
                      opponentSearch.disabled = false;
                      opponentContainer.style.display = 'block';
                      updateOpponentSelect();
                  } else {
                      opponentSearch.disabled = true;
                      opponentContainer.style.display = 'none';
                  }
              });
          });
      })
      .catch(error => console.error('Error fetching slots:', error))
      .finally(() => {
          // Hide loader
          loadingOverlay.style.display = 'none';
      });
  }



      dateInput.addEventListener('change', fetchAvailableSlots);
    // fetch when gender changes too!
  });
  

  const loggedInUser = "<%= loggedInUserFullName %>";
  console.log("Logged in user full name:", loggedInUser);

    document.addEventListener('DOMContentLoaded', function () {

      function checkPlayerBookingLimit(empName) {
        const selectedDate = document.getElementById("date").value;
        const selectedSlots = document.querySelectorAll("input[name='timeSlots']:checked").length;
        const loadingOverlay = document.getElementById('loadingOverlay');

        if (!selectedDate || selectedSlots === 0) {
          return;
        }
      loadingOverlay.style.display = 'flex';
        fetch('CheckBookingLimitServlet', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: 'empName=' + encodeURIComponent(empName) +
                '&date1=' + encodeURIComponent(selectedDate) +
                '&numSlots=' + encodeURIComponent(selectedSlots)
        })
        .then(response => response.text())
        .then(result => {
          if (result.trim() === "false") {
            alert(empName + " has exceeded the booking limit for this day.");

            // Uncheck Squad checkboxes
            const checkboxes = document.querySelectorAll("input[name='opponents']");
            checkboxes.forEach(box => {
              if (box.value === empName) {
                box.checked = false;
              }
            });

            // Deselect in Double select box
            const select = document.querySelector("select[name='opponent']");
            if (select && select.value === empName) {
              select.value = "";
            }

            // Uncheck the user's own time slot if this is self-check
            if (empName === loggedInUser) {
              const timeSlots = document.querySelectorAll("input[name='timeSlots']:checked");
              timeSlots.forEach(slot => slot.checked = false);
            }
          }
        })
    .catch(error => console.error('Error fetching slots:', error))
      .finally(() => {
          // Hide loader
          loadingOverlay.style.display = 'none';
      });
      }

      // 🟩 Validate the logged-in user when selecting time slots
      document.getElementById("timeSlotsContainer").addEventListener("change", function (event) {
        const target = event.target;

        if (target && target.name === "timeSlots" && target.checked) {
          checkPlayerBookingLimit(loggedInUser);
        }
      });

      // 🟩 Validate opponent selection (Squad & Double)
      document.getElementById("opponentList").addEventListener("change", function (event) {
        const target = event.target;

        if (target && (target.name === "opponents" || target.name === "opponent")) {
          const empName = target.value;

          if (target.checked || target.tagName === "SELECT") {
            checkPlayerBookingLimit(empName);
          }
        }
  });

    });

    // Initialize opponent list on load
    window.onload = updateOpponentSelect;
</script>

</body>
</html>
