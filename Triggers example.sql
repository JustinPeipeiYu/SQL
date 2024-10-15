----------------------------TRIGGERS---------------------------------------------------------

CREATE TABLE Employee
(  
    EmployeeID int NOT NULL,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    HireDate date,    
);

CREATE TABLE EmpLog (
   logID INT IDENTITY(1,1) NOT NULL
   , EmployeeID INT NOT NULL
   , FirstName NVARCHAR(50) NOT NULL
   , LastName NVARCHAR(50) NOT NULL
   , HireDate date NOT NULL
   , Operation NVARCHAR(50)
   , UpdatedOn DATETIME
   , UpdatedBy NVARCHAR(50)
   );
GO
-- Insert trigger
CREATE TRIGGER trgEmployeeInsert
ON Employee
FOR INSERT
AS
   INSERT INTO EmpLog(EmployeeID, FirstName, LastName, HireDate, Operation, UpdatedOn, UpdatedBy)
   SELECT EmployeeID, Firstname, LastName, HireDate, 'INSERT', GETDATE(), SUSER_NAME()
   FROM INSERTED;
GO

INSERT INTO Employee
VALUES(101, 'John','Rocks','05-12-2018'),
(112, 'Peter','King','01-01-2015');
GO
SELECT *
FROM EmpLog
ORDER BY EmployeeID;
GO