CREATE DATABASE UniversityDB;
USE UniversityDB;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Students VALUES
(1, 'John', 'Doe', 'john@example.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane@example.com', '2001-05-10', '2021-08-01');

INSERT INTO Courses VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

INSERT INTO Instructors VALUES
(1, 'Alice', 'Johnson', 'alice@univ.com', 1),
(2, 'Bob', 'Lee', 'bob@univ.com', 2);

INSERT INTO Enrollments VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

-- CRUD OPERATIONS 
-- Create
INSERT INTO Students VALUES (3, 'Mike', 'Ross', 'mike@example.com', '2002-03-12', '2023-01-10');

-- Read
SELECT * FROM Students;

-- Update
UPDATE Students SET Email='mike.ross@example.com' WHERE StudentID=3;

-- Delete
DELETE FROM Students WHERE StudentID=3;

-- STUDENTS ENROLLED AFTER 2022
SELECT * FROM Students
WHERE EnrollmentDate > '2022-12-31';

-- COURSES FOR MTHEMATICAL DEPARTMENT
SELECT c.*
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

-- COURSES WITH MORE THAN 5 STUDENTS
SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

-- STUDENTS IN BOTH SQL AND DATA STRUCTURES
SELECT s.StudentID, s.FirstName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102)
GROUP BY s.StudentID
HAVING COUNT(DISTINCT e.CourseID) = 2;

-- STUDENTS IN EITHER COURSE
SELECT DISTINCT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102);

-- AVERAGE CREDITS
SELECT AVG(Credits) AS AvgCredits FROM Courses;

-- INSTRUCTORS IN COMPUTER SCIENCE

SELECT *
FROM Instructors
WHERE DepartmentID = (
    SELECT DepartmentID FROM Departments
    WHERE DepartmentName = 'Computer Science'
);

-- COUNT STUDENTS PER DEPARTMENT
SELECT d.DepartmentName, COUNT(e.StudentID) AS TotalStudents
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

-- INNER JOIN STUDENT AND COURSES
SELECT s.FirstName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- LEFT JOIN
SELECT s.FirstName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- SUBQUERY
SELECT *
FROM Students
WHERE StudentID IN (
    SELECT StudentID
    FROM Enrollments
    GROUP BY StudentID
    HAVING COUNT(*) > 10
);

-- EXTRACT YEAR
SELECT StudentID, YEAR(EnrollmentDate) AS Year
FROM Students;

-- FULL INSTRUCTOR NAME
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Instructors;