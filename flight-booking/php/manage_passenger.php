<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');

include 'db_connect.php';

$action = $_POST['action'] ?? $_GET['action'] ?? '';

function jsonResponse($status, $message, $data = null)
{
    echo json_encode([
        'status' => $status,
        'message' => $message,
        'data' => $data
    ]);
    exit;
}

if ($action === 'save') {
    $firstname = $_POST['P_Firstname'] ?? '';
    $lastname = $_POST['P_Lastname'] ?? '';
    $email = $_POST['Email'] ?? '';
    $passport_number = $_POST['Passport_Number'] ?? '';
    $dob = $_POST['Date_Of_Birth'] ?? '';
    $gender = $_POST['Gender'] ?? '';
    $country_code = $_POST['Country_Code'] ?? '';
    $tel_number = $_POST['Tel_Number'] ?? '';

    // Auto-generate Passenger_ID
    $result = $conn->query("SELECT COUNT(*) AS total FROM Passengers");
    $count = $result->fetch_assoc()['total'] + 1;
    $passenger_id = "P" . str_pad($count, 3, '00', STR_PAD_LEFT);

    $stmt = $conn->prepare("INSERT INTO Passengers (Passenger_ID, P_Firstname, P_Lastname, Gender, Email, Passport_Number, Date_Of_Birth) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssss", $passenger_id, $firstname, $lastname, $gender, $email, $passport_number, $dob);

    if ($stmt->execute()) {
        if (!empty($country_code) && !empty($tel_number)) {
            $stmt_phone = $conn->prepare("INSERT INTO PhoneNumbers (Passenger_ID, Country_Code, Tel_Number) VALUES (?, ?, ?)");
            $stmt_phone->bind_param("sss", $passenger_id, $country_code, $tel_number);
            $stmt_phone->execute();
            $stmt_phone->close();
        }
        jsonResponse("success", "Passenger added successfully!");
    } else {
        jsonResponse("error", "Error inserting passenger: " . $stmt->error);
    }

    $stmt->close();
} elseif ($action === 'update') {
    $passenger_id = $_POST['Passenger_ID'] ?? '';
    $firstname = $_POST['P_Firstname'] ?? '';
    $lastname = $_POST['P_Lastname'] ?? '';
    $email = $_POST['Email'] ?? '';
    $passport_number = $_POST['Passport_Number'] ?? '';
    $dob = $_POST['Date_Of_Birth'] ?? '';
    $gender = $_POST['Gender'] ?? '';
    $country_code = $_POST['Country_Code'] ?? '';
    $tel_number = $_POST['Tel_Number'] ?? '';

    $stmt = $conn->prepare("UPDATE Passengers SET P_Firstname=?, P_Lastname=?, Gender=?, Email=?, Passport_Number=?, Date_Of_Birth=? WHERE Passenger_ID=?");
    $stmt->bind_param("sssssss", $firstname, $lastname, $gender, $email, $passport_number, $dob, $passenger_id);

    if ($stmt->execute()) {
        $check = $conn->prepare("SELECT * FROM PhoneNumbers WHERE Passenger_ID=?");
        $check->bind_param("s", $passenger_id);
        $check->execute();
        $res = $check->get_result();

        if ($res->num_rows > 0) {
            $stmt_phone = $conn->prepare("UPDATE PhoneNumbers SET Country_Code=?, Tel_Number=? WHERE Passenger_ID=?");
        } else {
            $stmt_phone = $conn->prepare("INSERT INTO PhoneNumbers (Country_Code, Tel_Number, Passenger_ID) VALUES (?, ?, ?)");
        }

        $stmt_phone->bind_param("sss", $country_code, $tel_number, $passenger_id);
        $stmt_phone->execute();
        $stmt_phone->close();

        jsonResponse("success", "Passenger updated successfully!");
    } else {
        jsonResponse("error", "Error updating passenger: " . $stmt->error);
    }

    $stmt->close();
} elseif ($action === 'delete') {
    $passenger_id = $_POST['Passenger_ID'] ?? '';

    $stmt_phone = $conn->prepare("DELETE FROM phonenumbers WHERE Passenger_ID=?");
    $stmt_phone->bind_param("s", $passenger_id);
    $stmt_phone->execute();
    $stmt_phone->close();

    $stmt = $conn->prepare("DELETE FROM Passengers WHERE Passenger_ID=?");
    $stmt->bind_param("s", $passenger_id);

    if ($stmt->execute()) {
        jsonResponse("success", "Passenger deleted successfully!");
    } else {
        jsonResponse("error", "Error deleting passenger: " . $stmt->error);
    }

    $stmt->close();
} elseif ($action === 'read') {
    $result = $conn->query("SELECT p.*, ph.Country_Code, ph.Tel_Number
                            FROM Passengers p
                            LEFT JOIN PhoneNumbers ph ON p.Passenger_ID = ph.Passenger_ID
                            ORDER BY p.Passenger_ID ASC");

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode($data);
    exit;
} else {
    jsonResponse("error", "Invalid or missing action.");
}

$conn->close();
