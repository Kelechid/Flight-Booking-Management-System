<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

include 'db_connect.php';

$type = $_GET['type'] ?? '';

if ($type === 'cancelled_bookings') {
    $query = "CALL get_passengers_with_cancelled_bookings()";
    $result = $conn->query($query);  // ✅ This line was missing in your original code

    if ($result) {
        $rows = [];
        while ($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }
        echo json_encode($rows);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to execute procedure.']);
    }
}

$conn->close();
