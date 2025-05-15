-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 15, 2025 at 11:48 AM
-- Server version: 8.2.0
-- PHP Version: 8.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `skybook`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `get_passengers_with_cancelled_bookings`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_passengers_with_cancelled_bookings` ()   BEGIN
    SELECT 
        p.Passenger_ID,
        p.P_Firstname,
        p.P_Lastname,
        b.Booking_ID,
        b.Booking_Status
    FROM Bookings b
    INNER JOIN Passengers p ON p.Passenger_ID = b.Passenger_ID
    WHERE b.Booking_Status = 'cancelled';
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `calculate_discount`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_discount` (`amount` DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE discount DECIMAL(10,2);
    IF amount >= 500 THEN
        SET discount = amount * 0.10;
    ELSE
        SET discount = amount * 0.05;
    END IF;
    RETURN discount;
END$$

DROP FUNCTION IF EXISTS `get_title_name`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_title_name` (`firstname` VARCHAR(50), `lastname` VARCHAR(50), `gender` VARCHAR(10)) RETURNS VARCHAR(150) CHARSET utf8mb4 DETERMINISTIC BEGIN
    DECLARE full_title VARCHAR(150);
    IF LOWER(gender) = 'female' THEN
        SET full_title = CONCAT('Ms. ', firstname, ' ', lastname);
    ELSE
        SET full_title = CONCAT('Mr. ', firstname, ' ', lastname);
    END IF;
    RETURN full_title;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `aircrafts`
--

DROP TABLE IF EXISTS `aircrafts`;
CREATE TABLE IF NOT EXISTS `aircrafts` (
  `Aircraft_ID` varchar(20) NOT NULL,
  `Airline_ID` varchar(20) NOT NULL,
  `Aircraft_Type` varchar(50) DEFAULT NULL,
  `Manufacturer` varchar(50) DEFAULT NULL,
  `Registration_Number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Aircraft_ID`),
  KEY `Airline_ID` (`Airline_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `aircrafts`
--

INSERT INTO `aircrafts` (`Aircraft_ID`, `Airline_ID`, `Aircraft_Type`, `Manufacturer`, `Registration_Number`) VALUES
('N-A32D', 'BA', 'Boeing 737', 'Boeing', 'R001345'),
('N-534A', 'AP', 'Airbus 380', 'Airbus', 'R001842'),
('P-643J', 'TK', 'Boeing 737', 'Boeing', 'R001356'),
('G-986C', 'LA', 'Boeing 757', 'Boeing', 'R001946'),
('P-I734', 'EA', 'Airbus A319', 'Airbus', 'R001567'),
('P-765I', 'QA', 'Bombardier Global 5000', 'Bombardier', 'R001782'),
('P-674A', 'AA', 'Gulfstream G450', 'Gulfstream', 'R001436'),
('P-534T', 'TK', 'Airbus 380', 'Airbus', 'R001826'),
('N-D543', 'AP', 'Boeing 737', 'Boeing', 'R001452'),
('M-109B', 'FG', 'Hawker Hurricane', 'Hawker Aircraft', 'R001122');

-- --------------------------------------------------------

--
-- Table structure for table `airlines`
--

DROP TABLE IF EXISTS `airlines`;
CREATE TABLE IF NOT EXISTS `airlines` (
  `Airline_ID` varchar(20) NOT NULL,
  `Airline_Name` varchar(30) NOT NULL,
  `Contact_Number` varchar(20) DEFAULT NULL,
  `Operating_Region` varchar(15) NOT NULL,
  PRIMARY KEY (`Airline_ID`,`Airline_Name`,`Operating_Region`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `airlines`
--

INSERT INTO `airlines` (`Airline_ID`, `Airline_Name`, `Contact_Number`, `Operating_Region`) VALUES
('BA', 'British Airways', '547382992', 'North America'),
('EA', 'Emirates Airlines', '125012342', 'Asia'),
('TK', 'Turkish Airlines', '015694230', 'Europe'),
('AP', 'Air Peace', '836524673', 'Africa'),
('EA', 'Emirates Airlines', '125012342', 'Middle East'),
('LA', 'Lufthansa Airlines', '01265732', 'Europe'),
('LA', 'Lufthansa Airlines', '01265732', 'Africa'),
('TK', 'Turkish Airlines', '015694230', 'South America'),
('BA', 'British Airways', '547382992', 'Africa'),
('QA', 'Qatar Airways', '562328942', 'Middle East'),
('AA', 'Arcus Air', '783456723', 'Europe');

-- --------------------------------------------------------

--
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
CREATE TABLE IF NOT EXISTS `airports` (
  `Airport_ID` varchar(10) NOT NULL,
  `Airport_Name` varchar(70) NOT NULL,
  `Aircraft_ID` varchar(20) DEFAULT NULL,
  `City` varchar(15) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`Airport_ID`),
  KEY `Aircraft_ID` (`Aircraft_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `airports`
--

INSERT INTO `airports` (`Airport_ID`, `Airport_Name`, `Aircraft_ID`, `City`, `Country`) VALUES
('ECN', 'Ercan International Airport', 'P-I734', 'Lefkosa', 'North Cyprus'),
('CDG', 'Charles De Gaulle Airport', 'P-674A', 'Paris', 'France'),
('IST', 'Istanbul Airport', 'P-643J', 'Istanbul', 'Turkey'),
('JFK', 'John F.Kennedy International Airport', 'N-A32D', 'New York', 'United States'),
('NRT', 'Narita International Airport', 'P-I734', 'Tokyo', 'Japan'),
('ABV', 'Nnamdi Azikiwe International Airport', 'N-D543', 'Abuja', 'Nigeria'),
('ADL', 'Adelaide International Airport', 'P-643J', 'Adelaide', 'Australia'),
('FRA', 'Frankfurt Airport', 'G-986C', 'Frankfurt', 'Germany'),
('JRO', 'Kilimanjaro International Airport', 'N-D543', 'Kilimanjaro', 'Tanzania'),
('CAI', 'Cairo International Airport', 'G-986C', 'Cairo', 'Egypt'),
('DEL', 'Indira Gandhi International Airport', 'P-765I', 'Delhi', 'India'),
('CPT', 'Cape Town International Airport', 'N-534A', 'Cape Town', 'South Africa'),
('DOH', 'Doha Hamad International Airport', 'P-765I', 'Doha', 'Qatar'),
('ADA', 'Adana Airport', 'P-534T', 'Adana', 'Turkey'),
('LHR', 'Heathrow Airport', 'N-A32D', 'London', 'United Kingdom'),
('OTP', 'Henri Coanda International Airport', 'G-986C', 'Bucharest', 'Romania'),
('NAP', 'Napoli International Airport', 'P-674A', 'Naples', 'Italy'),
('NAN', 'Nadi International Airport', 'P-I734', 'Nadi', 'Fiji'),
('IAD', 'Dulles International Airport', 'N-A32D', 'Washington DC', 'United States'),
('DXB', 'Dubai International Airport', 'P-I734', 'Dubai', 'UAE'),
('PEK', 'Beijing Capital International Airport', 'M-109B', 'Beijing', 'China'),
('EZE', 'Ministro Pistarini International Airport', 'P-643J', 'Buenos Aires', 'Argentina'),
('GRU', 'Sao Paulo Airport', 'P-534T', 'Sao Paulo', 'Brazil'),
('LOS', 'Murtala Muhammed International Airport', 'N-534A', 'Lagos', 'Nigeria');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `Booking_ID` varchar(15) NOT NULL,
  `Flight_ID` varchar(20) NOT NULL,
  `Airline_Name` varchar(30) NOT NULL,
  `Passenger_ID` varchar(20) NOT NULL,
  `Seat_Number` varchar(5) DEFAULT NULL,
  `Booking_DateTime` datetime DEFAULT NULL,
  `Booking_Status` varchar(10) DEFAULT NULL,
  `Total_Amount` decimal(10,2) NOT NULL,
  `Payment_Status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`Booking_ID`),
  KEY `Flight_ID` (`Flight_ID`),
  KEY `Passenger_ID` (`Passenger_ID`),
  KEY `Airline_Name` (`Airline_Name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`Booking_ID`, `Flight_ID`, `Airline_Name`, `Passenger_ID`, `Seat_Number`, `Booking_DateTime`, `Booking_Status`, `Total_Amount`, `Payment_Status`) VALUES
('B0001', 'F0004', 'Emirates Airlines', 'P0001', '4E', '2024-05-05 09:30:07', 'Pending', 890.00, 'Failed'),
('B0002', 'F0002', 'Air Peace', 'P0006', '10A', '2024-04-12 11:30:16', 'Pending', 1250.78, 'Failed'),
('B0003', 'F0006', 'Turkish Airlines', 'P0009', '15E', '2024-03-12 13:00:10', 'Pending', 1550.56, 'Failed'),
('B0004', 'F0001', 'Air Peace', 'P0004', '22C', '2024-05-02 10:00:32', 'Pending', 665.00, 'Failed'),
('B0005', 'F0006', 'Turkish Airlines', 'P0009', '15E', '2024-03-12 13:45:21', 'Pending', 1560.56, 'Failed'),
('B0006', 'F0005', 'Arcus Air', 'P0010', '1D', '2024-04-30 08:10:45', 'Pending', 1170.23, 'Failed'),
('B0007', 'F0003', 'Lufthansa Airlines', 'P0003', '30B', '2024-02-01 09:05:05', 'Pending', 517.74, 'Failed'),
('B0008', 'F0007', 'Qatar Airways', 'P0005', '5F', '2024-05-08 12:00:45', 'Pending', 900.76, 'Failed');

-- --------------------------------------------------------

--
-- Table structure for table `flights`
--

DROP TABLE IF EXISTS `flights`;
CREATE TABLE IF NOT EXISTS `flights` (
  `Flight_ID` varchar(25) NOT NULL,
  `Flight_Number` varchar(25) NOT NULL,
  `D_DateTime` datetime NOT NULL,
  `A_DateTime` datetime NOT NULL,
  `D_Airport_ID` varchar(10) NOT NULL,
  `A_Airport_ID` varchar(10) NOT NULL,
  `Available_Seats` int DEFAULT NULL,
  `Total_Seats` varchar(10) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Flight_ID`),
  KEY `D_Airport_ID` (`D_Airport_ID`),
  KEY `A_Airport_ID` (`A_Airport_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `flights`
--

INSERT INTO `flights` (`Flight_ID`, `Flight_Number`, `D_DateTime`, `A_DateTime`, `D_Airport_ID`, `A_Airport_ID`, `Available_Seats`, `Total_Seats`, `Price`) VALUES
('F0002', 'BA237', '2024-05-18 21:30:00', '2024-05-20 22:00:00', 'ECN', 'MEX', 10, '90', 1200.56),
('F0003', 'EA846', '2024-05-19 20:00:00', '2024-05-21 14:10:00', 'FRA', 'JRO', 2, '45', 400.06),
('F0004', 'EA297', '2024-05-18 18:30:00', '2024-05-19 15:00:00', 'PEK', 'NRT', 0, '50', 815.56),
('F0005', 'LA756', '2024-05-18 21:30:00', '2024-05-20 22:00:00', 'CDG', 'NAP', 7, '65', 1000.40),
('F0006', 'TK274', '2024-05-20 16:30:00', '2024-05-22 13:15:00', 'EZE', 'OTP', 1, '70', 1500.56),
('F0001', 'AP472', '2024-05-19 19:00:00', '2024-05-20 10:00:00', 'ABV', 'CPT', 5, '50', 615.86);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `log_message` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`log_id`, `log_message`, `created_at`) VALUES
(1, 'Phone number added: 7015419049', '2025-05-10 17:32:12'),
(2, 'Phone number added: 666666', '2025-05-10 19:50:49'),
(3, 'Phone number added: 555555', '2025-05-10 20:43:18'),
(4, 'Phone number added: 7015419049', '2025-05-10 21:11:46'),
(5, 'Phone number added: 5391055984', '2025-05-11 00:57:42'),
(6, 'Phone number added: 5402160993', '2025-05-11 03:23:28'),
(7, 'Phone number added: 7015419049', '2025-05-11 13:04:58');

-- --------------------------------------------------------

--
-- Table structure for table `passengers`
--

DROP TABLE IF EXISTS `passengers`;
CREATE TABLE IF NOT EXISTS `passengers` (
  `Passenger_ID` varchar(25) NOT NULL,
  `P_Firstname` varchar(50) NOT NULL,
  `P_Lastname` varchar(50) NOT NULL,
  `Gender` varchar(10) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Passport_Number` varchar(25) NOT NULL,
  `Date_Of_Birth` date NOT NULL,
  PRIMARY KEY (`Passenger_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `passengers`
--

INSERT INTO `passengers` (`Passenger_ID`, `P_Firstname`, `P_Lastname`, `Gender`, `Email`, `Passport_Number`, `Date_Of_Birth`) VALUES
('P0001', 'Lasisi', 'Alex', 'Male', 'lasisia@gmail.com', 'LA01345567', '1994-05-20'),
('P0002', 'Shank', 'Fred', 'Male', 'freds1@yahoo.com', 'LA01345555', '1990-02-15'),
('P0003', 'Joy', 'Mark', 'Female', 'joymark1@gmail.com', 'BA01334575', '2000-07-01'),
('P0004', 'Ella', 'Wong', 'Female', 'wongella5@gmail.com', 'MD01245658', '2002-03-25'),
('P0005', 'John', 'Lee', 'Male', 'johnlee72@yahoo.com', 'MD01245678', '1980-11-05'),
('P0006', 'Catherine', 'Zach', 'Female', 'cathiez@gmail.com', 'BA01335428', '2001-09-17'),
('P0007', 'Eunice', 'Gold', 'Female', 'egold19@yahoo.com', 'LA01345565', '1990-02-24'),
('P0008', 'Faith', 'Emmanuel', 'Female', 'faithe23@yahoo.com', 'LA01345565', '2003-08-10'),
('P0009', 'David', 'Samuel', 'Male', 'davids9@yahoo.com', 'MD01245669', '1999-12-07'),
('P0010', 'Daniel', 'James', 'Male', 'jamesd15@yahoo.com', 'BA01334769', '2000-10-12');

-- --------------------------------------------------------

--
-- Table structure for table `passenger_aircraft`
--

DROP TABLE IF EXISTS `passenger_aircraft`;
CREATE TABLE IF NOT EXISTS `passenger_aircraft` (
  `Aircraft_ID` varchar(20) NOT NULL,
  `Aircraft_Class` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`Aircraft_ID`)
) ;

--
-- Dumping data for table `passenger_aircraft`
--

INSERT INTO `passenger_aircraft` (`Aircraft_ID`, `Aircraft_Class`) VALUES
('P-534T', 'Local'),
('P-723W', 'International'),
('N-D543', 'Local'),
('N-A32D', 'International'),
('N-534A', 'Local'),
('P-I734', 'International'),
('G-986C', 'International'),
('P-534K', 'Local'),
('P-723B', 'International');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE IF NOT EXISTS `payments` (
  `Payment_ID` varchar(20) NOT NULL,
  `Booking_ID` varchar(20) NOT NULL,
  `Payment_Method` varchar(25) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `Transaction_DateTime` datetime NOT NULL,
  PRIMARY KEY (`Payment_ID`),
  KEY `Booking_ID` (`Booking_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`Payment_ID`, `Booking_ID`, `Payment_Method`, `Amount`, `Transaction_DateTime`) VALUES
('PAY00001A', 'B0007', 'Debit Card', 517.74, '2024-02-01 09:06:10'),
('PAY00001B', 'B0003', 'Paypal', 1550.56, '2024-03-12 13:01:50'),
('PAY00001C', 'B0005', 'Paypal', 1550.56, '2024-03-12 13:47:15'),
('PAY00001D', 'B0002', 'Google Pay', 1250.78, '2024-04-12 11:32:23'),
('PAY00001E', 'B0006', 'Credit card', 1170.23, '2024-04-30 08:11:20'),
('PAY00001F', 'B0004', 'Google Pay', 665.00, '2024-05-02 10:02:03'),
('PAY00001G', 'B0001', 'Debit Card', 890.00, '2024-05-05 09:32:10'),
('PAY00001H', 'B0008', 'Paypal', 900.76, '2024-05-08 12:01:17'),
('PAY00001I', 'B0009', 'Apple Pay', 1200.56, '2024-05-10 10:15:17'),
('PAY00001J', 'B0010', 'Credit Card', 1500.56, '2024-05-11 14:00:17');

-- --------------------------------------------------------

--
-- Table structure for table `phonenumbers`
--

DROP TABLE IF EXISTS `phonenumbers`;
CREATE TABLE IF NOT EXISTS `phonenumbers` (
  `Passenger_ID` varchar(20) NOT NULL,
  `Country_Code` varchar(10) DEFAULT NULL,
  `Tel_Number` varchar(15) DEFAULT NULL,
  KEY `Passenger_ID` (`Passenger_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `phonenumbers`
--

INSERT INTO `phonenumbers` (`Passenger_ID`, `Country_Code`, `Tel_Number`) VALUES
('P0001', '+90', '5423891086'),
('P0002', '+234', '7076423259'),
('P0002', '+234', '8075325135'),
('P0003', '+27', '5432863273'),
('P0004', '+233', '7063421346'),
('P0005', '+1', '7865432219'),
('P0006', '+27', '5684216984'),
('P0008', '+44', '7097856316'),
('P0009', '+230', '9085342175'),
('P0010', '+91', '7574533423'),
('P0010', '+91', '8036534696'),
('P0011', 'Türkiye', '7015419049'),
('P0012', '+56', '9007642335'),
('P0015', '+60', '5480063428'),
('P0015', '+60', '90775345324'),
('P0016', '+90', '5402160993');

--
-- Triggers `phonenumbers`
--
DROP TRIGGER IF EXISTS `log_phone_changes`;
DELIMITER $$
CREATE TRIGGER `log_phone_changes` AFTER INSERT ON `phonenumbers` FOR EACH ROW BEGIN
    INSERT INTO logs (log_message, created_at)
    VALUES (CONCAT('Phone number added: ', NEW.Tel_Number), NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `specialized_aircraft`
--

DROP TABLE IF EXISTS `specialized_aircraft`;
CREATE TABLE IF NOT EXISTS `specialized_aircraft` (
  `Aircraft_ID` varchar(20) NOT NULL,
  `Aircraft_Purpose` varchar(20) DEFAULT NULL,
  KEY `Aircraft_ID` (`Aircraft_ID`)
) ;

--
-- Dumping data for table `specialized_aircraft`
--

INSERT INTO `specialized_aircraft` (`Aircraft_ID`, `Aircraft_Purpose`) VALUES
('P-765I', 'Private Ownership'),
('M-H784', 'Military'),
('P-6433', 'Government'),
('M-109B', 'Military'),
('P-674A', 'Private Ownership'),
('G-6G34', 'Government'),
('P-8620', 'Private Ownership');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fullname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL,
  `registered_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fullname`, `email`, `password`, `role`, `registered_at`) VALUES
(1, 'Kelechi David', 'Kelechid47@gmail.com', 'secret', 'customer', '2025-05-07 08:09:24'),
(2, 'John Katende', 'prodbyyoungmogul@gmail.com', 'music', 'admin', '2025-05-07 17:51:04'),
(3, 'summer love', 'Kelechid47@hotmail.com', 'summer', 'customer', '2025-05-07 18:30:54'),
(4, 'jj', 'Kelechid47@hot.com', 'hot', 'accountant', '2025-05-10 08:15:57');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
