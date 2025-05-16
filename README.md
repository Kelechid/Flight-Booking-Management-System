# Flight-Booking-Management-System
Please note that all the JavaScript, HTML, CSS, and PHP files are in the flight booking folder.

💻 Technologies Used

    Frontend: HTML, CSS, JavaScript

    Backend: PHP

    Database: Oracle SQL & PL/SQL (connected via WAMP/Apache and PHP's OCI functions)

👥 User Roles

    Admin
![Screenshot 2025-05-11 141413](https://github.com/user-attachments/assets/20b6d50c-8372-458b-9f77-3af954f82105)

        Full CRUD for Flights and Passengers

        Views all data via dashboard
        

    Customer
    
![Screenshot 2025-05-11 005655](https://github.com/user-attachments/assets/f285da27-f897-4722-9889-0fec4fa8c55b)

        Registers and logs in

        Manages their own bookings and passenger records

    Accountant

       
        Updates booking and payment statuses

        Views financial outliers and discounts

        Accesses special PL/SQL-powered reports

🛠️ Key Features
✅ Authentication

    Secure login/register pages

    Role-based dashboard redirection

✈️ Booking & Passenger Management

    Full CRUD for:

        Flights

        Passengers (with auto-generated Passenger_ID in P00X format)

☎️ Phone Numbers Table

    Linked to passengers via Passenger_ID

    Tracked automatically by a trigger (see below)

🧠 Oracle PL/SQL Features
🔁 Triggers

CREATE OR REPLACE TRIGGER log_phone_changes
AFTER INSERT OR UPDATE OR DELETE ON phonenumbers
FOR EACH ROW
BEGIN
  INSERT INTO phonenumbers_log (...) VALUES (...);
END;

    Purpose: Automatically log any changes to the phonenumbers table.

    No PHP or JS needed — this works purely in the database.

📉 PL/SQL Functions

    calculate_discount

FUNCTION calculate_discount(total_amount NUMBER) RETURN NUMBER

    Returns 10% discount if amount > 1000, otherwise 5%.

get_title_name

    FUNCTION get_title_name(gender VARCHAR2, fname VARCHAR2, lname VARCHAR2) RETURN VARCHAR2

        Prepends "Ms." or "Mr." based on gender and returns full name.

📊 Accountant Dashboard Enhancements

Under Manage Status:

    ✅ Update booking and payment status

    📋 View bookings not equal to the average payment

    🎯 Full integration of PL/SQL functions:

        get_title_name() used to prefix names

        calculate_discount() values displayed in table

🧾 SQL Query for Payment Outliers

SELECT bookings.Booking_ID, passengers.Passenger_ID, bookings.Airline_Name,
  get_title_name(passengers.Gender, passengers.P_Firstname, passengers.P_Lastname) AS Passenger_Name,
  passengers.Gender,
  bookings.Total_Amount,
  calculate_discount(bookings.Total_Amount) AS Discount
FROM bookings
INNER JOIN passengers ON bookings.Passenger_ID = passengers.Passenger_ID
WHERE bookings.Total_Amount <> (
    SELECT AVG(bookings.Total_Amount) FROM bookings
)

🧪 Sample Data Flow

    Customer registers → logs in → creates a booking.

    Admin views/manages flights/passengers.

    Accountant:

        Updates booking/payment status.

        Views outliers and discount calculations (via PL/SQL).

    Trigger logs any phone number updates.

🚀 How to Run

    Start Apache & Oracle DB (WAMP, XAMPP + Oracle XE).

    Place the project in your web root:

    C:\wamp64\www\skybook\flight-booking\

    Set up your Oracle DB schema with:

        Tables: passengers, flights, bookings, phonenumbers, phonenumbers_log

        Functions & Triggers

    Update php/db_connection.php with your Oracle DB credentials.

📌 Notes

    Be sure Oracle and Apache are both running.

    Triggers and PL/SQL functions are independent of frontend logic.

    Dashboard views are controlled by JavaScript file in /js/.

🙌 Credits

Built by a Software Engineering student as part of a full-stack university project involving real-world data integration, frontend/backend separation, and Oracle PL/SQL techniques.

