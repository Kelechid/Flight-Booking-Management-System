<?php
include 'db_connect.php';

$type = $_GET['type'];
$result = [];

if ($type === 'most-booked') {
    $sql = "SELECT f.Flight_Number, COUNT(b.Booking_ID) AS Total_Bookings
            FROM Flights f
            JOIN Bookings b ON f.Flight_ID = b.Flight_ID
            GROUP BY f.Flight_Number
            ORDER BY Total_Bookings DESC";
} elseif ($type === 'airport-revenue') {
    $sql = "SELECT a.Airport_Name, SUM(f.Price) AS Total_Revenue
            FROM Flights f
            JOIN Airports a ON f.A_Airport_ID = a.Airport_ID
            JOIN Bookings b ON f.Flight_ID = b.Flight_ID
            GROUP BY a.Airport_Name
            ORDER BY Total_Revenue DESC";
} elseif ($type === 'daily-bookings') {
    $sql = "SELECT DATE(b.Booking_DateTime) AS Booking_Date, COUNT(*) AS Total_Bookings
            FROM Bookings b
            GROUP BY Booking_Date
            ORDER BY Booking_Date DESC";
} elseif ($type === 'cancelled_bookings') {
    $sql = "SELECT p.Passenger_ID, p.Name, b.Booking_ID, b.Status
            FROM passengers p
            JOIN bookings b ON p.Passenger_ID = b.Passenger_ID
            WHERE b.Status = 'Cancelled'";
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid query type']);
    exit;
}


$query = $conn->query($sql);

while ($row = $query->fetch_assoc()) {
    $result[] = $row;
}

echo json_encode($result);
$conn->close();
