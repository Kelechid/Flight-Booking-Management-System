<?php
include 'db_connect.php';
header('Content-Type: application/json');

$query = "
SELECT 
    b.Booking_ID,
    p.Passenger_ID,
    b.Airline_Name,
    get_title_name(p.P_Firstname, p.P_Lastname, p.Gender) AS Passenger_Name,
    p.Gender,
    b.Total_Amount,
    calculate_discount(b.Total_Amount) AS Discount
FROM bookings b
JOIN passengers p ON b.Passenger_ID = p.Passenger_ID
WHERE b.Total_Amount <> (SELECT AVG(Total_Amount) FROM bookings)

";

$result = $conn->query($query);
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(['status' => 'success', 'data' => $data]);
$conn->close();
