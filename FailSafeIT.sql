-- ===========================================================================
--
--           FailSafeIT - When you don't want to flip your tables
--                             
-- An SQL assignment, Class: DevSecOps KYH-2026
-- Author: Carl-Henrik Alm 
-- ===========================================================================

USE FailSafeIT
GO

DROP TABLE IF EXISTS ASSIGNMENTS;
DROP TABLE IF EXISTS CONSULTANTS;
DROP TABLE IF EXISTS CUSTOMERS;
GO



-- ===========================================================================
-- DDL section creates the database structure and enforces data integrity 
-- ===========================================================================

CREATE TABLE [CUSTOMERS] (
  [CustomerId] INT PRIMARY KEY IDENTITY(1,1),
  [OrganizationNumber] VARCHAR(50) NOT NULL UNIQUE,
  [CompanyName] NVARCHAR(200) NOT NULL,
  [Email] NVARCHAR(100) NOT NULL,
  [Phone] VARCHAR(50) NOT NULL
);

CREATE TABLE [CONSULTANTS] (
  [ConsultantId] INT PRIMARY KEY IDENTITY(1,1),
  [PersonalNumber] VARCHAR(50) NOT NULL UNIQUE,
  [FirstName] NVARCHAR(50) NOT NULL,
  [LastName] NVARCHAR(50) NOT NULL,
  [HourlyRate] DECIMAL(10,2) NOT NULL
        CHECK (HourlyRate > 0),
  [Specialty] VARCHAR(150) NOT NULL
);

CREATE TABLE [ASSIGNMENTS] (
  [AssignmentId] INT PRIMARY KEY IDENTITY (1,1),
  [CustomerId] INT NOT NULL,
  [ConsultantId] INT NOT NULL,
  [StartDate] DATETIME2 NOT NULL,
  [EndDate] DATETIME2 NULL,
  [RoleDescription] VARCHAR(200) NOT NULL,

  CHECK (EndDate IS NULL OR EndDate >= StartDate),

  CONSTRAINT [FK_ASSIGNMENTS_CustomerId]
    FOREIGN KEY ([CustomerId])
      REFERENCES [CUSTOMERS]([CustomerId]),

  CONSTRAINT [FK_ASSIGNMENTS_ConsultantId]
    FOREIGN KEY ([ConsultantId])
      REFERENCES [CONSULTANTS]([ConsultantId])
);



-- ===========================================================================
-- DML section populates the database with realistic test data
-- ===========================================================================

INSERT INTO CUSTOMERS
(
    OrganizationNumber,
    CompanyName,
    Email,
    Phone
)
VALUES
('556123-4567', 'Northwind Solutions AB', 'contact@northwind.se', '070-1234567'),
('556234-5678', 'Scandinavian Tech Group', 'info@scanditech.se', '070-2345678'),
('556345-6789', 'CloudMatrix Sweden AB', 'hello@cloudmatrix.se', '070-3456789'),
('556456-7890', 'Digital Core Systems AB', 'support@digitalcore.se', '070-4567890'),
('556567-8901', 'SafeNet Consulting AB', 'office@safenet.se', '070-5678901'),
('556678-9012', 'Innova Solutions AB', 'info@innova.se', '070-6789012'),
('556789-0123', 'Peak Performance IT AB', 'contact@peakit.se', '070-7890123'),
('556890-1234', 'FutureStack Technologies AB', 'mail@futurestack.se', '070-8901234'),
('556901-2345', 'BlueRiver Systems AB', 'support@blueriver.se', '070-9012345'),
('556012-3456', 'Nexus Digital AB', 'hello@nexusdigital.se', '070-0123456'),
('559999-9999', 'Delete Me AB', 'delete@demo.se','070-9999999');
INSERT INTO CONSULTANTS
(
    PersonalNumber,
    FirstName,
    LastName,
    HourlyRate,
    Specialty
)
VALUES
('19890115-1234', 'Erik', 'Johansson', 1450.00, 'Software Developer'),
('19920322-2345', 'Anna', 'Lindberg', 1650.00, 'Cloud Engineer'),
('19870511-3456', 'Johan', 'Karlsson', 1300.00, 'DevOps Engineer'),
('19951108-4567', 'Emma', 'Nilsson', 1200.00, 'Cybersecurity Analyst'),
('19881130-5678', 'Daniel', 'Svensson', 1500.00, 'Systems Administrator'),
('19940118-6789', 'Sara', 'Andersson', 1400.00, 'Network Administrator'),
('19860703-7890', 'Marcus', 'Berg', 1750.00, 'Blockchain Engineer'),
('19970212-8901', 'Lisa', 'Ekström', 1100.00, 'IT Support Specialist'),
('19840427-9012', 'Fredrik', 'Holm', 1900.00, 'IT Project Manager'),
('19900815-0123', 'Maja', 'Persson', 1350.00, 'Business Analyst');

INSERT INTO ASSIGNMENTS
(
    CustomerId,
    ConsultantId,
    StartDate,
    EndDate,
    RoleDescription
)
VALUES
(1, 1, '2026-01-10', '2026-03-30', 'Backend development for internal business applications'),

(2, 2, '2026-02-01', '2026-06-15', 'Azure cloud migration project'),

(3, 3, '2026-01-15', '2026-05-01', 'CI/CD pipeline automation and deployment'),

(4, 4, '2026-03-01', '2026-07-01', 'Security audit of public facing APIs'),

(5, 5, '2026-01-20', '2026-04-20', 'Server infrastructure modernization'),

(6, 6, '2026-02-12', '2026-05-12', 'Corporate network redesign'),

(7, 7, '2026-03-15', '2026-09-15', 'Blockchain proof of concept platform'),

(8, 8, '2026-01-05', '2026-02-28', 'Service desk implementation'),

(9, 9, '2026-04-01', '2026-10-01', 'Enterprise IT transformation project'),

(10, 10, '2026-02-10', '2026-06-10', 'Business process analysis and optimization'),

(1, 2, '2026-04-01', '2026-08-01', 'Cloud infrastructure improvements'),

(2, 3, '2026-05-01', '2026-09-01', 'DevOps coaching and automation'),

(3, 4, '2026-04-15', '2026-07-15', 'Cybersecurity risk assessment'),

(4, 5, '2026-02-15', '2026-08-15', 'Windows server administration'),

(5, 6, '2026-03-20', '2026-09-20', 'Site-to-site network implementation'),

(6, 7, '2026-05-10', '2026-12-01', 'Distributed ledger architecture design'),

(7, 8, '2026-06-01', '2026-08-01', 'End user support rollout'),

(8, 9, '2026-02-20', '2026-11-15', 'Strategic IT project leadership'),

(9, 10, '2026-03-10', '2026-06-30', 'Requirements gathering and business analysis'),

(10, 1, '2026-05-15', '2026-10-15', 'Development of customer portal features');



-- ===========================================================================
-- Query A
-- Lists all consultants with an hourly rate above 1200 SEK 
-- ===========================================================================

SELECT
    FirstName,
    LastName,
    HourlyRate
FROM CONSULTANTS
WHERE HourlyRate > 1200
ORDER BY HourlyRate DESC;



-- ===========================================================================
-- Query B
-- Displays a complete assignment overview 
-- by combining data from multiple tables.
-- ===========================================================================

SELECT
    c.CompanyName AS Customer,
    con.FirstName + ' ' + con.LastName AS Consultant,
    a.StartDate,
    a.EndDate
FROM ASSIGNMENTS a
INNER JOIN CUSTOMERS c
    ON a.CustomerId = c.CustomerId
INNER JOIN CONSULTANTS con
    ON a.ConsultantId = con.ConsultantId
ORDER BY a.StartDate;



-- ===========================================================================
-- Query C
-- Active Assignments per Customer
--
-- Comment out 'AND a.EndDate >= GETDATE()' to count all assignments.
-- ===========================================================================

SELECT
    c.CompanyName,
    COUNT(a.AssignmentId) AS TotalAssignments
FROM CUSTOMERS c
LEFT JOIN ASSIGNMENTS a
    ON c.CustomerId = a.CustomerId
    AND a.EndDate >= GETDATE()     
GROUP BY c.CompanyName
ORDER BY TotalAssignments DESC;



-- ===========================================================================
-- Query D
-- Consultant Rate Update
-- ===========================================================================

UPDATE CONSULTANTS
SET HourlyRate = 2000.00
WHERE PersonalNumber = '19890115-1234';

SELECT
    ConsultantId,
    FirstName,
    LastName,
    PersonalNumber,
    HourlyRate
FROM CONSULTANTS
WHERE ConsultantId = 1;



-- ===========================================================================
-- Query E1 
-- Remove a Prospect Customer
-- ===========================================================================

SELECT
    c.CustomerId,
    c.CompanyName
FROM CUSTOMERS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM ASSIGNMENTS a
    WHERE a.CustomerId = c.CustomerId
    AND a.EndDate >= GETDATE()
);


DELETE FROM CUSTOMERS
WHERE CustomerId = 11
AND NOT EXISTS
(
    SELECT 1
    FROM ASSIGNMENTS
    WHERE CustomerId = 11
    AND EndDate >= GETDATE()
);

SELECT *
FROM CUSTOMERS
WHERE CustomerId = 11;


-- ===========================================================================
-- Query E2
-- Remove a Former Customer
-- ===========================================================================

DELETE FROM ASSIGNMENTS
WHERE CustomerId = 1
  AND EndDate < GETDATE();

DELETE FROM CUSTOMERS
WHERE CustomerId = 1;


