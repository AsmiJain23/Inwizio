CREATE DATABASE HRManagement;
USE HRManagement;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL,
    ManagerID INT
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    HireDate DATE NOT NULL,
    DepartmentID INT,
    ManagerID INT,
    Salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE PerformanceReviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    ReviewDate DATE NOT NULL,
    PerformanceScore ENUM('Excellent', 'Good', 'Average', 'Poor') NOT NULL,
    Comments TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Payroll (
    PayrollID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod ENUM('Bank Transfer', 'Check') NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Departments (DepartmentName, ManagerID)
VALUES ('Human Resources', NULL),
       ('Finance', NULL),
       ('IT', NULL),
       ('Sales', NULL);
       
INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, DepartmentID, ManagerID, Salary)
VALUES ('Anu', 'taneja', 'anu.doe@example.com', '1234567890', '2022-05-15', 1, NULL, 55000.00),
       ('jini', 'jain', 'jini.smith@example.com', '9876543210', '2023-03-10', 2, 1, 65000.00),
       ('hasan', 'khan', 'hasan.johnson@example.com', '1112223333', '2023-07-01', 3, 2, 75000.00),
       ('bilal', 'abbas', 'bilal.brown@example.com', '4445556666', '2024-01-20', 4, 2, 80000.00);
       
INSERT INTO PerformanceReviews (EmployeeID, ReviewDate, PerformanceScore, Comments)
VALUES (1, '2023-01-15', 'Good', 'Met expectations'),
       (2, '2023-06-20', 'Excellent', 'Exceeded expectations'),
       (3, '2023-08-10', 'Average', 'Needs improvement'),
       (4, '2024-02-01', 'Poor', 'Underperformed');

INSERT INTO Payroll (EmployeeID, PaymentDate, Amount, PaymentMethod)
VALUES (1, '2023-03-01', 55000.00, 'Bank Transfer'),
       (2, '2023-03-01', 65000.00, 'Check'),
       (3, '2023-08-01', 75000.00, 'Bank Transfer'),
       (4, '2024-01-20', 80000.00, 'Bank Transfer');

-- 1 Retrieve the names and contact details of employees hired after January 1, 2023.

SELECT FirstName, LastName, Email, Phone
FROM Employees
WHERE HireDate > '2023-01-01';

-- 2 Find the total payroll amount paid to each department.
SELECT d.DepartmentName, SUM(p.Amount) AS TotalPayroll
FROM Payroll p
JOIN Employees e ON p.EmployeeID = e.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;


-- 3 List all employees who have not been assigned a manager
SELECT EmployeeID, FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL;

-- 4 Retrieve the highest salary in each department along with the employee’s name

SELECT d.DepartmentName, e.FirstName, e.LastName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = (
    SELECT MAX(Salary)
    FROM Employees e2
    WHERE e2.DepartmentID = e.DepartmentID
);

-- 5 Find the most recent performance review for each employee.
SELECT e.EmployeeID, e.FirstName, e.LastName, pr.ReviewDate, pr.PerformanceScore
FROM Employees e
JOIN PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
WHERE pr.ReviewDate = (
    SELECT MAX(ReviewDate)
    FROM PerformanceReviews pr2
    WHERE pr2.EmployeeID = e.EmployeeID
);

-- 6 Count the number of employees in each department.

SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

-- 7 List all employees who have received a performance score of "Excellent." 

SELECT e.FirstName, e.LastName, pr.PerformanceScore
FROM Employees e
JOIN PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
WHERE pr.PerformanceScore = 'Excellent';

-- Most frequently used payment method:
SELECT PaymentMethod, COUNT(*) AS Frequency
FROM Payroll
GROUP BY PaymentMethod
ORDER BY Frequency DESC
LIMIT 1;

-- Retrieve the top 5 highest-paid employees along with their departments.
SELECT e.FirstName, e.LastName, e.Salary, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.Salary DESC
LIMIT 5;

-- Show details of all employees who report directly to a specific manager (e.g., ManagerID = 101).
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.Phone
FROM Employees e
WHERE e.ManagerID = 101;



