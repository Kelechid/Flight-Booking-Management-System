<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

include 'db_connect.php';

$booking_id = $_POST['booking_id'] ?? '';
$booking_status = $_POST['booking_status'] ?? '';
$payment_status = $_POST['payment_status'] ?? '';

if (!$booking_id) {
    echo "Booking ID is required.";
    exit;
}

$stmt = $conn->prepare("UPDATE Bookings SET Booking_Status = ?, Payment_Status = ? WHERE Booking_ID = ?");
$stmt->bind_param("ssi", $booking_status, $payment_status, $booking_id);

if ($stmt->execute()) {
    echo "Booking updated successfully.";
} else {
    echo "Error updating booking: " . $stmt->error;
}

$conn->close();
