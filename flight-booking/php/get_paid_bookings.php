<?php
include 'db_connect.php';

$query = "
SELECT 
    bookings.Booking_ID,
    CONCAT_WS(' ', passengers.P_Firstname, passengers.P_Lastname) AS Passenger_Name,
    flights.Flight_Number,
    passengers.Passport_Number,
    bookings.Seat_Number,
    flights.D_DateTime,
    flights.A_DateTime,
    flights.D_Airport_ID,
    flights.A_Airport_ID,
    bookings.Payment_Status
FROM bookings
INNER JOIN flights ON bookings.Flight_ID = flights.Flight_ID
INNER JOIN passengers ON bookings.Passenger_ID = passengers.Passenger_ID
WHERE bookings.Payment_Status = 'Paid'
";

$result = $conn->query($query);

if ($result->num_rows > 0) {
    echo "<table border='1'>
            <tr>
                <th>Booking ID</th>
                <th>Passenger Name</th>
                <th>Flight Number</th>
                <th>Passport Number</th>
                <th>Seat Number</th>
                <th>D_DateTime</th>
                <th>A_DateTime</th>
                <th>D_Airport_ID</th>
                <th>A_Airport_ID</th>
                <th>Payment Status</th>
            </tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>{$row['Booking_ID']}</td>
                <td>{$row['Passenger_Name']}</td>
                <td>{$row['Flight_Number']}</td>
                <td>{$row['Passport_Number']}</td>
                <td>{$row['Seat_Number']}</td>
                <td>{$row['D_DateTime']}</td>
                <td>{$row['A_DateTime']}</td>
                <td>{$row['D_Airport_ID']}</td>
                <td>{$row['A_Airport_ID']}</td>
                <td>{$row['Payment_Status']}</td>
              </tr>";
    }
    echo "</table>";
} else {
    echo "<p>No paid bookings found.</p>";
}

$conn->close();
