<?php
include 'db_connect.php';
$result = $conn->query("SELECT * FROM Flights");
$flights = [];
while ($row = $result->fetch_assoc()) {
    $flights[] = $row;
}
echo json_encode($flights);
$conn->close();
