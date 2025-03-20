-- Add more students
INSERT INTO Students (FirstName, LastName, Email, EnrollmentDate)
VALUES 
('Maria', 'Garcia', 'maria.garcia@example.com', '2023-08-15'),
('Ahmed', 'Khan', 'ahmed.khan@example.com', '2023-09-01'),
('Sarah', 'Johnson', 'sarah.j@example.com', '2023-09-15');
GO

-- Add more courses
INSERT INTO Courses (CourseName, Credits, Department)
VALUES 
('Advanced Database Design', 4, 'Computer Science'),
('Mobile App Development', 3, 'Computer Science'),
('Network Security', 4, 'Information Technology');
GO

-- Add more enrollments
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, Grade)
VALUES 
(1, 4, '2023-09-15', 'B+'),
(2, 5, '2023-09-01', 'A-'),
(3, 6, '2023-09-15', 'B'),
(4, 1, '2023-08-15', 'A'),
(5, 3, '2023-09-01', 'B+'),
(6, 2, '2023-09-15', 'A-');
GO

-- Query 1: List all students with their enrollment dates
SELECT StudentID, FirstName, LastName, Email, EnrollmentDate
FROM Students
ORDER BY EnrollmentDate;
GO

-- Query 2: Count students enrolled each day
SELECT EnrollmentDate, COUNT(*) AS NumberOfStudents
FROM Students
GROUP BY EnrollmentDate
ORDER BY EnrollmentDate;
GO

-- Query 3: List all courses with the number of enrolled students
SELECT c.CourseID, c.CourseName, c.Department, COUNT(e.StudentID) AS EnrolledStudents
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName, c.Department
ORDER BY EnrolledStudents DESC;
GO

-- Query 4: Find average grade by course (converting letter grades to numbers)
SELECT c.CourseID, c.CourseName,
       AVG(CASE 
           WHEN e.Grade = 'A' THEN 4.0
           WHEN e.Grade = 'A-' THEN 3.7
           WHEN e.Grade = 'B+' THEN 3.3
           WHEN e.Grade = 'B' THEN 3.0
           WHEN e.Grade = 'B-' THEN 2.7
           WHEN e.Grade = 'C+' THEN 2.3
           WHEN e.Grade = 'C' THEN 2.0
           WHEN e.Grade = 'C-' THEN 1.7
           WHEN e.Grade = 'D+' THEN 1.3
           WHEN e.Grade = 'D' THEN 1.0
           WHEN e.Grade = 'F' THEN 0.0
           ELSE NULL
       END) AS AverageGradePoint
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
ORDER BY AverageGradePoint DESC;
GO

-- Query 5: Create a student transcript report
SELECT 
    s.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    c.CourseName,
    c.Credits,
    e.Grade,
    CASE 
        WHEN e.Grade = 'A' THEN 4.0
        WHEN e.Grade = 'A-' THEN 3.7
        WHEN e.Grade = 'B+' THEN 3.3
        WHEN e.Grade = 'B' THEN 3.0
        WHEN e.Grade = 'B-' THEN 2.7
        WHEN e.Grade = 'C+' THEN 2.3
        WHEN e.Grade = 'C' THEN 2.0
        WHEN e.Grade = 'C-' THEN 1.7
        WHEN e.Grade = 'D+' THEN 1.3
        WHEN e.Grade = 'D' THEN 1.0
        WHEN e.Grade = 'F' THEN 0.0
        ELSE NULL
    END * c.Credits AS QualityPoints
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
ORDER BY s.LastName, s.FirstName, c.CourseName;
GO

-- Step 6: Create and Populate a New Table
-- Create Advisors table
CREATE TABLE Advisors (
    AdvisorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Department NVARCHAR(50)
);
GO

-- Add sample advisors
INSERT INTO Advisors (FirstName, LastName, Email, Department)
VALUES 
('Robert', 'Smith', 'robert.smith@university.edu', 'Computer Science'),
('Jennifer', 'Wong', 'jennifer.wong@university.edu', 'Information Technology'),
('Michael', 'Brown', 'michael.brown@university.edu', 'Computer Science');
GO

-- Add AdvisorID column to Students table
ALTER TABLE Students
ADD AdvisorID INT NULL;
GO

-- Assign advisors to students
UPDATE Students
SET AdvisorID = 1
WHERE StudentID IN (1, 4);

UPDATE Students
SET AdvisorID = 2
WHERE StudentID IN (2, 5);

UPDATE Students
SET AdvisorID = 3
WHERE StudentID IN (3, 6);
GO

-- Add foreign key constraint
ALTER TABLE Students
ADD CONSTRAINT FK_Students_Advisors
FOREIGN KEY (AdvisorID) REFERENCES Advisors(AdvisorID);
GO

-- Step 7: Create a Student Advisor Report
SELECT 
    s.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    s.Email AS StudentEmail,
    s.EnrollmentDate,
    a.FirstName + ' ' + a.LastName AS AdvisorName,
    a.Email AS AdvisorEmail,
    a.Department AS AdvisorDepartment,
    COUNT(e.EnrollmentID) AS CoursesEnrolled
FROM 
    Students s
    LEFT JOIN Advisors a ON s.AdvisorID = a.AdvisorID
    LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY 
    s.StudentID, s.FirstName, s.LastName, s.Email, s.EnrollmentDate,
    a.FirstName, a.LastName, a.Email, a.Department
ORDER BY 
    a.LastName, a.FirstName, s.LastName, s.FirstName;
GO

-- Step 9: Create Your Own Custom Query
