CREATE DATABASE University;
USE University;


CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100)
);


CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    enrollment_date DATE,
    department_id INT,
    FOREIGN KEY(department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150),
    phone VARCHAR(30)
);

CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    department_id INT,
    professor_id INT,
    credits INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
-- Insert data into Departments table
INSERT INTO Departments (department_name) VALUES
('Computer Science'),
('Civil Engineering'),
('Electronics & Communication'),
('Mechanical Engineering');

-- Insert data into Professors table
INSERT INTO Professors (first_name, last_name, email, phone) VALUES
('Rajeev', 'Verma', 'rajeev.verma@university.edu', '9012345678'),
('Meera', 'Sharma', 'meera.sharma@university.edu', '9123456789'),
('Aditya', 'Kumar', 'aditya.kumar@university.edu', '9234567890'),
('Ritika', 'Singh', 'ritika.singh@university.edu', '9345678901');

-- Insert data into Courses table
INSERT INTO Courses (course_name, department_id, professor_id, credits) VALUES
('Algorithms', 1, 1, 4),
('Structural Analysis', 2, 2, 3),
('Digital Signal Processing', 3, 3, 3),
('Thermodynamics', 4, 4, 4),
('Machine Learning', 1, 1, 3);

-- Insert data into Students table
INSERT INTO Students (first_name, last_name, email, phone, date_of_birth, enrollment_date, department_id) VALUES
('Ishita', 'Gupta', 'ishita.gupta@student.edu', '9876541230', '1999-01-15', '2023-07-01', 1),
('Rohan', 'Joshi', 'rohan.joshi@student.edu', '8765432190', '2000-04-18', '2023-07-01', 2),
('Sneha', 'Patil', 'sneha.patil@student.edu', '7654321980', '2001-09-22', '2023-07-01', 3),
('Vivek', 'Singhania', 'vivek.singhania@student.edu', '6543219870', '2000-12-31', '2023-07-01', 4),
('Ankita', 'Chopra', 'ankita.chopra@student.edu', '5432109876', '1998-07-08', '2023-07-01', 1);

-- Insert data into Enrollments table
INSERT INTO Enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2023-07-10', 'A'),
(1, 5, '2023-07-11', 'B'),
(2, 2, '2023-07-12', 'A'),
(3, 3, '2023-07-13', 'B'),
(4, 4, '2023-07-14', 'C'),
(5, 1, '2023-07-15', 'D'),
(5, 5, '2023-07-16', 'A');

-- Find the Total Number of Students in Each Department


SELECT d.department_name, COUNT(s.student_id) AS total_students
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
GROUP BY d.department_name;

-- List All Courses Taught by a Specific Professor

SELECT p.first_name , c.course_name
FROM Courses c
JOIN Professors p ON p.professor_id = c.professor_id
GROUP BY p.first_name , c.course_name;

-- Find the Average Grade of Students in Each Course

SELECT c.course_name , 
   AVG(
        CASE 
            WHEN e.grade = 'A' THEN 5
            WHEN e.grade = 'B' THEN 3
            WHEN e.grade = 'C' THEN 2
            WHEN e.grade = 'D' THEN 1
            ELSE 0 
        END
    ) AS average_grade
FROM Courses c
JOIN Enrollments e ON e.course_id = c.course_id 
GROUP BY c.course_name;

-- List All Students Who Have Not Enrolled in Any Courses

SELECT 
    s.student_id, 
    s.first_name, 
    s.last_name, 
    s.email, 
    s.phone
FROM 
    Students s
LEFT JOIN 
    Enrollments e ON s.student_id = e.student_id
WHERE 
    e.enrollment_id IS NULL; -- No matching enrollment
    
-- Find the Number of Courses Offered by Each Department   
DESC Courses;
DESC Departments;

SELECT d.department_name, COUNT(c.course_name) AS course_count
FROM Departments d
JOIN Courses c ON d.department_id = c.department_id
GROUP BY d.department_name;

-- . List All Students Who Have Taken a Specific Course (e.g., 'Database Systems')

SELECT s.first_name , c.course_name
FROM Students s 
JOIN Enrollments e ON e.student_id = s.student_id
JOIN Courses c ON c.course_id = e.course_id 
GROUP BY s.first_name,c.course_name;

-- 7. Find the Most Popular Course Based on Enrollment Numbers

SELECT c.course_name , COUNT(distinct E.student_id) as popularcourses
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1 ;

-- .8 Find the Average Number of Credits Per Student in a Department

SELECT d.department_name,
AVG(c.credits) AS avg_credits_per_student
FROM Departments d
JOIN Students s ON s.department_id = d.department_id 
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON c.course_id = e.course_id
GROUP BY d.department_name ; 
 


-- 9. List All Professors Who Teach in More Than One Department

SELECT p.first_name , p.last_name , COUNT(DISTINCT d.department_name) AS department_count
FROM Professors p 
JOIN Courses c ON c.professor_id = p.professor_id
JOIN Departments d ON d.department_id = c.department_id
GROUP BY p.professor_id
HAVING department_count>1 ;

-- 10. Get the Highest and Lowest Grade in a Specific Course (e.g., 'Operating Systems')

SELECT c.course_name,
       MAX(
           CASE 
               WHEN e.grade = 'A' THEN 4
               WHEN e.grade = 'B' THEN 3
               WHEN e.grade = 'C' THEN 2
               WHEN e.grade = 'D' THEN 1
               ELSE 0 
           END
       ) AS highest_grade_numeric,
       MIN(
           CASE 
               WHEN e.grade = 'A' THEN 4
               WHEN e.grade = 'B' THEN 3
               WHEN e.grade = 'C' THEN 2
               WHEN e.grade = 'D' THEN 1
               ELSE 0 
           END
       ) AS lowest_grade_numeric
FROM Courses c
JOIN Enrollments e ON e.course_id = c.course_id
WHERE c.course_name = 'Algorithms'
GROUP BY c.course_name;
