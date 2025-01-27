CREATE DATABASE RetailStoreDB;
USE RetailStoreDB;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    join_date DATE
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock_quantity INT
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10, 2),
    payment_method VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers (first_name, last_name, email, phone, address, join_date)
VALUES
('Anubhav', 'Taneja', 'anubhav.t@example.com', '9876543210', 'Bhopal, MP', '2023-01-15'),
('Asmi', 'Jain', 'asmi.j@example.com', '9988776655', 'Indore, MP', '2023-03-10'),
('Adi', 'Kumar', 'adi.k@example.com', '9123456780', 'Delhi, DL', '2023-05-20'),
('Arjun', 'Rathore', 'arjun.r@example.com', '9001234567', 'Mumbai, MH', '2023-07-05'),
('Harsh', 'Surana', 'harsh.s@example.com', '9786543211', 'Pune, MH', '2023-09-25'),
('Aditi', 'Srivas', 'aditi.s@example.com', '9012345678', 'Kolkata, WB', '2023-11-01');

INSERT INTO Products (product_name, category, price, stock_quantity)
VALUES
('Laptop', 'Electronics', 50000.00, 10),
('Smartphone', 'Electronics', 20000.00, 20),
('Desk Chair', 'Furniture', 3000.00, 15),
('Dining Table', 'Furniture', 15000.00, 5),
('Refrigerator', 'Appliances', 25000.00, 8),
('Air Conditioner', 'Appliances', 30000.00, 6);

INSERT INTO Orders (customer_id, order_date, total_amount, order_status)
VALUES
(1, '2024-01-10', 70000.00, 'Shipped'),
(2, '2024-01-15', 23000.00, 'Pending'),
(3, '2024-01-20', 45000.00, 'Shipped'),
(4, '2024-01-25', 15000.00, 'Pending'),
(5, '2024-01-28', 55000.00, 'Shipped'),
(6, '2024-01-30', 6000.00, 'Shipped');

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 50000.00),
(1, 2, 1, 20000.00),
(2, 3, 2, 1500.00),
(3, 5, 1, 25000.00),
(3, 6, 1, 30000.00),
(4, 4, 1, 15000.00),
(5, 2, 2, 20000.00),
(5, 1, 1, 50000.00),
(6, 3, 2, 3000.00);

INSERT INTO Payments (order_id, payment_date, payment_amount, payment_method)
VALUES
(1, '2024-01-11', 70000.00, 'Credit Card'),
(3, '2024-01-21', 45000.00, 'PayPal'),
(5, '2024-01-29', 55000.00, 'Credit Card'),
(6, '2024-01-31', 6000.00, 'Cash');

-- 1. Find the Total Number of Orders for Each Customer
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 2. Find the Total Sales Amount for Each Product (Revenue per Product)
SELECT p.product_name, SUM(od.quantity * od.unit_price) AS total_sales
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id;

-- 3. Find the Most Expensive Product Sold

SELECT p.product_name, MAX(od.unit_price) AS max_price
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_name
LIMIT 0, 1000;

-- 4. Customers Who Placed Orders in the Last 30 Days
SELECT c.first_name, c.last_name, o.order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 5. Total Amount Paid by Each Customer
SELECT c.first_name, c.last_name, SUM(p.payment_amount) AS total_paid
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id;

-- 6. Number of Products Sold by Category

SELECT p.category, SUM(od.quantity) AS total_sold
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.category;

-- 7. List All Orders That Are Pending (i.e., Orders that haven't been shipped yet

SELECT o.order_id, c.first_name, c.last_name, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Pending';

-- 8. Find the Average Order Value (Total Order Amount / Number of Orders)

SELECT AVG(total_amount) AS average_order_value
FROM Orders;

-- 9 9. Top 5 Customers Who Spent the Most Money
SELECT c.first_name, c.last_name, SUM(p.payment_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 10 
SELECT p.product_name
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
WHERE od.order_id IS NULL;

