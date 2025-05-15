<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);


include 'db_connect.php';


$passenger_id = $_POST['passenger_id'] ?? '';
$tel_number = $_POST['tel_number'] ?? '';
$country_code = $_POST['country_code'] ?? ''; // optional

if ($passenger_id && $tel_number) {
    $stmt = $conn->prepare("INSERT INTO PhoneNumbers (Passenger_ID, Country_Code, Tel_Number) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $passenger_id, $country_code, $tel_number);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo json_encode(['status' => 'success', 'message' => 'Phone number added.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Insertion failed.']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input.']);
}

$conn->close();
