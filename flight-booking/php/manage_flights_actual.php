<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json');
include 'db_connect.php';



if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'];
    $flight_id = $_POST['flight_id'] ?? '';
    $flight_number = $_POST['flight_number'] ?? '';
    $d_datetime = $_POST['d_datetime'] ?? '';
    $a_datetime = $_POST['a_datetime'] ?? '';
    $d_airport_id = $_POST['d_airport_id'] ?? '';
    $a_airport_id = $_POST['a_airport_id'] ?? '';
    $available_seats = $_POST['available_seats'] ?? '';
    $total_seats = $_POST['total_seats'] ?? '';
    $price = $_POST['price'] ?? '';

    if ($action === 'add') {
        $stmt = $conn->prepare("INSERT INTO Flights (Flight_ID, Flight_Number, D_DateTime, A_DateTime, D_Airport_ID, A_Airport_ID, Available_Seats, Total_Seats, Price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssssisd", $flight_id, $flight_number, $d_datetime, $a_datetime, $d_airport_id, $a_airport_id, $available_seats, $total_seats, $price);
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Flight added successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to add flight']);
        }
        $stmt->close();
    } elseif ($action === 'update') {
        $query = "UPDATE Flights SET ";
        $fields = [];
        $params = [];
        $types = "";

        if (!empty($flight_number)) {
            $fields[] = "Flight_Number = ?";
            $params[] = &$flight_number;
            $types .= "s";
        }
        if (!empty($d_datetime)) {
            $fields[] = "D_DateTime = ?";
            $params[] = &$d_datetime;
            $types .= "s";
        }
        if (!empty($a_datetime)) {
            $fields[] = "A_DateTime = ?";
            $params[] = &$a_datetime;
            $types .= "s";
        }
        if (!empty($d_airport_id)) {
            $fields[] = "D_Airport_ID = ?";
            $params[] = &$d_airport_id;
            $types .= "s";
        }
        if (!empty($a_airport_id)) {
            $fields[] = "A_Airport_ID = ?";
            $params[] = &$a_airport_id;
            $types .= "s";
        }
        if (!empty($available_seats)) {
            $fields[] = "Available_Seats = ?";
            $params[] = &$available_seats;
            $types .= "i";
        }
        if (!empty($total_seats)) {
            $fields[] = "Total_Seats = ?";
            $params[] = &$total_seats;
            $types .= "s";
        }
        if (!empty($price)) {
            $fields[] = "Price = ?";
            $params[] = &$price;
            $types .= "d";
        }

        if (!empty($fields)) {
            $query .= implode(", ", $fields) . " WHERE Flight_ID = ?";
            $params[] = &$flight_id;
            $types .= "s";
            $stmt = $conn->prepare($query);
            $stmt->bind_param($types, ...$params);
            if ($stmt->execute()) {
                echo json_encode(['status' => 'success', 'message' => 'Flight updated successfully']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Update failed']);
            }
            $stmt->close();
        }
    } elseif ($action === 'delete') {
        $stmt = $conn->prepare("DELETE FROM Flights WHERE Flight_ID = ?");
        $stmt->bind_param("s", $flight_id);
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Flight deleted successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Deletion failed']);
        }
        $stmt->close();
    }

    $conn->close();
}
