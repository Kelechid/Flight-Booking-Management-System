<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json');

include 'db_connect.php';

$action = $_POST['action'] ?? '';

if ($action === 'save') {
    // Get form data
    $P_Firstname = $_POST['P_Firstname'] ?? null;
    $P_Lastname = $_POST['P_Lastname'] ?? null;
    $Email = $_POST['Email'] ?? null;
    $Passport_Number = $_POST['Passport_Number'] ?? null;
    $Date_Of_Birth = $_POST['Date_Of_Birth'] ?? null;
    $Gender = $_POST['Gender'] ?? null;
    $Country_Code = $_POST['Country_Code'] ?? null;
    $Tel_Number = $_POST['Tel_Number'] ?? null;

    // Basic validation
    if (!$P_Firstname || !$P_Lastname || !$Email || !$Passport_Number || !$Date_Of_Birth) {
        echo json_encode(['status' => 'error', 'message' => 'Required fields missing']);
        exit;
    }

    // Generate Passenger_ID
    $countResult = $conn->query("SELECT COUNT(*) as count FROM Passengers");
    $countRow = $countResult->fetch_assoc();
    $count = $countRow['count'] + 1;
    $Passenger_ID = 'P' . str_pad($count, 3, '0', STR_PAD_LEFT);

    // Insert into Passengers
    $stmt = $conn->prepare("INSERT INTO Passengers (Passenger_ID, P_Firstname, P_Lastname, Gender, Email, Passport_Number, Date_Of_Birth) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssss", $Passenger_ID, $P_Firstname, $P_Lastname, $Gender, $Email, $Passport_Number, $Date_Of_Birth);
    $stmt->execute();

    // Insert into phonenumbers
    if ($Country_Code && $Tel_Number) {
        $stmtPhone = $conn->prepare("INSERT INTO phonenumbers (Passenger_ID, Country_Code, Tel_Number) VALUES (?, ?, ?)");
        $stmtPhone->bind_param("sss", $Passenger_ID, $Country_Code, $Tel_Number);
        $stmtPhone->execute();
    }

    echo json_encode(['status' => 'success', 'message' => 'Passenger added successfully.']);
    exit;
}

if ($action === 'update') {
    $Passenger_ID = $_POST['Passenger_ID'] ?? null;
    if (!$Passenger_ID) {
        echo json_encode(['status' => 'error', 'message' => 'Passenger_ID is required for update']);
        exit;
    }

    $P_Firstname = $_POST['P_Firstname'] ?? null;
    $P_Lastname = $_POST['P_Lastname'] ?? null;
    $Email = $_POST['Email'] ?? null;
    $Passport_Number = $_POST['Passport_Number'] ?? null;
    $Date_Of_Birth = $_POST['Date_Of_Birth'] ?? null;
    $Gender = $_POST['Gender'] ?? null;
    $Country_Code = $_POST['Country_Code'] ?? null;
    $Tel_Number = $_POST['Tel_Number'] ?? null;

    // Update Passengers
    $stmt = $conn->prepare("UPDATE Passengers SET P_Firstname=?, P_Lastname=?, Gender=?, Email=?, Passport_Number=?, Date_Of_Birth=? WHERE Passenger_ID=?");
    $stmt->bind_param("sssssss", $P_Firstname, $P_Lastname, $Gender, $Email, $Passport_Number, $Date_Of_Birth, $Passenger_ID);
    $stmt->execute();

    // Update phonenumbers
    if ($Country_Code && $Tel_Number) {
        $stmtPhone = $conn->prepare("REPLACE INTO phonenumbers (Passenger_ID, Country_Code, Tel_Number) VALUES (?, ?, ?)");
        $stmtPhone->bind_param("sss", $Passenger_ID, $Country_Code, $Tel_Number);
        $stmtPhone->execute();
    }

    echo json_encode(['status' => 'success', 'message' => 'Passenger updated successfully.']);
    exit;
}

if ($action === 'delete') {
    $Passenger_ID = $_POST['Passenger_ID'] ?? null;
    if (!$Passenger_ID) {
        echo json_encode(['status' => 'error', 'message' => 'Passenger_ID is required for deletion']);
        exit;
    }

    // Delete from phonenumbers first due to FK constraint
    $conn->query("DELETE FROM phonenumbers WHERE Passenger_ID = '$Passenger_ID'");
    $conn->query("DELETE FROM Passengers WHERE Passenger_ID = '$Passenger_ID'");

    echo json_encode(['status' => 'success', 'message' => 'Passenger deleted successfully.']);
    exit;
}

echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
$conn->close();
