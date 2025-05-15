<?php
include 'db_connect.php';

echo "<pre>";
print_r($_POST);
echo "</pre>";


if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // Use null coalescing operator to prevent "undefined index" errors
  $full_name = $_POST['fullname'] ?? null;
  $email = $_POST['email'] ?? null;
  $password = $_POST['password'] ?? null;
  $role = $_POST['role'] ?? null;

  // Check if any required field is missing
  if (!$full_name || !$email || !$password || !$role) {
    echo "Please fill in all fields.";
    exit();
  }


  // Optional: Hash the password for better security
  // $password = password_hash($password, PASSWORD_DEFAULT);

  // Check if email already exists
  $check_stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
  $check_stmt->bind_param("s", $email);
  $check_stmt->execute();
  $check_stmt->store_result();

  if ($check_stmt->num_rows > 0) {
    echo "Email already registered.";
    $check_stmt->close();
    $conn->close();
    exit();
  }
  $check_stmt->close();

  // Insert user
  $stmt = $conn->prepare("INSERT INTO users (fullname, email, password, role) VALUES (?, ?, ?, ?)");
  $stmt->bind_param("ssss", $full_name, $email, $password, $role);

  if ($stmt->execute()) {
    echo "<script>
      alert('Registration successful!');
      window.location.href = '../login.html';
    </script>";
  } else {
    echo "Error: " . $stmt->error;
  }

  $stmt->close();
  $conn->close();
}
