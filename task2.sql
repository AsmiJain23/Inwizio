CREATE DATABASE OLA;
USE OLA;

CREATE TABLE Drivers(
	DriverID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Phone VARCHAR(15),                     
    City VARCHAR(50),                       
    VehicleType VARCHAR(20),                
    Rating DECIMAL(2, 1)                     
);
    

CREATE TABLE Riders (
    RiderID INT PRIMARY KEY AUTO_INCREMENT, 
    FirstName VARCHAR(50),                  
    LastName VARCHAR(50),                   
    Phone VARCHAR(15),                      
    City VARCHAR(50),                       
    JoinDate DATE                          
);

CREATE TABLE Rides (
    RideID INT PRIMARY KEY AUTO_INCREMENT,
    RiderID INT,  
    DriverID INT,
    RideDate DATE,
    PickupLocation VARCHAR(100),
    DropLocation VARCHAR(100),
    Distance DECIMAL(5, 2),
    Fare DECIMAL(10, 2),
    RideStatus VARCHAR(20),
    FOREIGN KEY (RiderID) REFERENCES Riders(RiderID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    RideID INT,
    PaymentMethod VARCHAR(50),
    Amount DECIMAL(10, 2),
    PaymentDate DATETIME,
    FOREIGN KEY (RideID) REFERENCES Rides(RideID)
);

    
INSERT INTO Drivers (FirstName, LastName, Phone, City, VehicleType, Rating)
VALUES 
('Asmi', 'Jain', '123-456-7890', 'Bhopal', 'Sedan', 4.9),
('Adi', 'Kumar', '987-654-3210', 'New Delhi', 'SUV', 4.7),
('Achal', 'Shah', '555-123-4567', 'Mumbai', 'Hatchback', 4.3),
('Soumya', 'Porwal', '333-444-5555', 'Chennai', 'Sedan', 4.8),
('Kunal', 'Singh', '666-777-8888', 'Kolkata', 'Luxury', 4.6);

-- Inserting data into Riders table
INSERT INTO Riders (FirstName, LastName, Phone, City, JoinDate)
VALUES 
('Asmi', 'Jain', '123-456-7890', 'Bhopal', '2024-01-01'),
('Adi', 'Kumar', '987-654-3210', 'New Delhi', '2024-01-05'),
('Achal', 'Shah', '555-123-4567', 'Mumbai', '2024-01-10'),
('Soumya', 'Porwal', '333-444-5555', 'Chennai', '2024-01-12'),
('Kunal', 'Singh', '666-777-8888', 'Kolkata', '2024-01-15');

-- Inserting data into Rides table
INSERT INTO Rides (RiderID, DriverID, RideDate, PickupLocation, DropLocation, Distance, Fare, RideStatus)
VALUES
(1, 1, '2024-01-10', 'Central Park', 'Times Square', 5.0, 25.50, 'Completed'),
(2, 2, '2024-01-12', 'Hollywood Blvd', 'Santa Monica Pier', 10.0, 45.75, 'Ongoing'),
(3, 3, '2024-01-15', 'Millennium Park', 'Navy Pier', 8.5, 38.00, 'Cancelled'),
(4, 4, '2024-01-18', 'Chennai Central', 'Marina Beach', 7.5, 35.00, 'Completed'),
(5, 5, '2024-01-20', 'Howrah Bridge', 'Victoria Memorial', 6.0, 30.00, 'Ongoing');

-- Inserting data into Payments table
INSERT INTO Payments (RideID, PaymentMethod, Amount, PaymentDate)
VALUES
(1, 'Credit Card', 25.50, '2024-01-10 14:30:00'),
(2, 'PayPal', 45.75, '2024-01-12 16:00:00'),
(3, 'Cash', 38.00, '2024-01-15 18:00:00'),
(4, 'Credit Card', 35.00, '2024-01-18 17:30:00'),
(5, 'Debit Card', 30.00, '2024-01-20 19:00:00');

-- 1. Retrieve the names and contact details of all drivers with a rating of 4.5 or higher.

SELECT FirstName , Phone
FROM Drivers 
WHERE Rating >= 4.5 ;

--  Find the total number of rides completed by each driver.

SELECT d.FirstName, d.LastName, COUNT(r.RideID) AS TotalCompletedRides
FROM Drivers d
JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed'
GROUP BY d.DriverID;


SELECT r.DriverID, COUNT(r.RideID) AS TotalCompletedRides
FROM Rides r
WHERE r.RideStatus = 'Completed'
GROUP BY r.DriverID;

-- 3. List all riders who have never booked a ride

SELECT r.FirstName,r.LastName
FROM Riders r 
LEFT JOIN Rides rr ON r.RiderID = rr.RiderID
WHERE rr.RideID IS NULL ;

-- 4 Calculate the total earnings of each driver from completed rides

SELECT SUM(rr.Fare) , rr.DriverID
FROM Rides rr 
WHERE rr.RideStatus = "Completed"
GROUP BY rr.DriverID;


SELECT * 
FROM Rides 
WHERE DriverID IN (1, 4) AND RideStatus = 'Completed';


CREATE TEMPORARY TABLE temp_rides AS
SELECT MIN(RideID) AS RideID
FROM Rides
WHERE RideStatus = 'Completed'
GROUP BY DriverID, PickupLocation, DropLocation;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM Payments
WHERE RideID NOT IN (SELECT RideID FROM temp_rides);

DELETE FROM Rides
WHERE RideID NOT IN (SELECT RideID FROM temp_rides);

SET foreign_key_checks = 1;


SELECT SUM(rr.Fare) , rr.DriverID
FROM Rides rr 
WHERE rr.RideStatus = "Completed"
GROUP BY rr.DriverID;

-- 5. Retrieve the most recent ride for each rider.
SELECT r.RiderID, r.FirstName, r.LastName, MAX(rd.RideDate) AS RecentRide
FROM Riders r
JOIN Rides rd ON r.RiderID = rd.RiderID
GROUP BY r.RiderID, r.FirstName, r.LastName;

-- 6. Count the number of rides taken in each city.

SELECT COUNT(r.RideID) , rr.City AS City
FROM Rides r 
JOIN Riders rr ON r.RiderID = rr.RiderID
GROUP BY rr.City;

-- 7. List all rides where the distance was greater than 20 km.
SELECT r.Distance , r.RideID
FROM Rides r
WHERE r.Distance >= 6.0;

--   8. Identify the most preferred payment method.
SELECT MAX(p.PaymentMethod) 
FROM Payments p;


-- 9. Find the top 3 highest-earning drivers

SELECT d.FirstName, d.LastName, SUM(r.Fare) AS TotalEarnings
FROM Drivers d
JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed'
GROUP BY d.DriverID, d.FirstName, d.LastName
ORDER BY TotalEarnings DESC
LIMIT 3;

-- 10. Retrieve details of all cancelled rides along with the rider's and driver's names.

SELECT 
    r.FirstName AS RiderName, 
    d.FirstName AS DriverName
FROM 
    Rides rr
JOIN 
    Riders r ON rr.RiderID = r.RiderID
JOIN 
    Drivers d ON rr.DriverID = d.DriverID
WHERE 
    rr.RideStatus = 'Cancelled';

