<?php
include 'db_connect.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $email = $_POST['email'] ?? '';
  $password = $_POST['password'] ?? '';
  $role = $_POST['role'] ?? '';

  if (empty($email) || empty($password) || empty($role)) {
    echo "Please fill in all fields.";
    exit();
  }

  // Fetch user
  $stmt = $conn->prepare("SELECT id, password FROM users WHERE email = ? AND role = ?");
  $stmt->bind_param("ss", $email, $role);
  $stmt->execute();
  $stmt->store_result();

  if ($stmt->num_rows > 0) {
    $stmt->bind_result($user_id, $db_password);
    $stmt->fetch();

    // Use this if you stored hashed passwords
    // if (password_verify($password, $db_password)) {

    if ($password === $db_password) { // for plain text testing
      // Login success - redirect based on role
      switch ($role) {
        case 'admin':
          header("Location: ../admin-dashboard.html");
          break;
        case 'customer':
          header("Location: ../customer-dashboard.html");
          break;
        case 'accountant':
          header("Location: ../accountant-dashboard.html");
          break;
        case 'technical':
          header("Location: ../technical-dashboard.html");
          break;
      }
      exit();
    } else {
      echo "Invalid password.";
    }
  } else {
    echo "No user found with that email and role.";
  }

  $stmt->close();
  $conn->close();
}
