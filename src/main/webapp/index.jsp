<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="login.css">
    <title>Login</title>
</head>
<body>
<div class="container">
  <img src="background_login.png" alt="" class="backimg">

  <div class="login-form">
   
    <input type="file" id="avatar-input" accept="image/*" style="display: none;">
    
    <input type="text" id="username" placeholder="User Name" class="username">
    <input type="password" id="password" placeholder="Password" class="password">
    <button class="button1" onclick="validateForm()">Login</button>
  </div>
</div>

<script>
  // Avatar image upload
  const avatarInput = document.getElementById('avatar-input');
  const avatar = document.getElementById('avatar');

  avatar.addEventListener('click', function () {
    avatarInput.click();
  });

  avatarInput.addEventListener('change', function () {
    const file = this.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function () {
        avatar.src = reader.result;
      };
      reader.readAsDataURL(file);
    }
  });

  function validateForm() {
  const username = document.getElementById("username").value.trim();
  const password = document.getElementById("password").value;

  if (username === "" || password === "") {
    alert("Please enter both username and password.");
    return;
  }

  if (password.length < 6) {
    alert("Password must be at least 6 characters long.");
    return;
  }

  // If validation passes, redirect to another page
  window.location.href = "homepage_user.jsp"; // <-- Replace with your target page
}

</script>
</body>
</html>
