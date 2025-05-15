<h2>All Payments</h2>
<?php
include 'db_connect.php';
// Fetch all payments
include 'php/db_connect.php';
$result = $conn->query("SELECT * FROM Payments");
while ($row = $result->fetch_assoc()) {
    echo "<div>Booking: {$row['Booking_ID']} - Amount: {$row['Amount']} - Method: {$row['Payment_Method']}</div>";
}
?>