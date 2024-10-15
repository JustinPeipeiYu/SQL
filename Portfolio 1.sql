--Task 1 --Create a table on the filegroup
ALTER DATABASE AdventureWorksLT2022
ADD FILEGROUP ReadOnlyFG1;
GO
CREATE TABLE AdventureWorksLT2022.dbo.MyReadOnlyTable
( FirstName varchar(50),
LastName varchar(50),
EMailAddress char(1000) )
ON ReadOnlyFG1;

--Display contents of the tables that are joined in the next step 
SELECT * FROM sys.indexes
SELECT * FROM sys.filegroups
SELECT * FROM sys.all_objects

--verify the table and filegroup were created
USE AdventureWorksLT2022
SELECT o.[name], o.[type], f.[name] FROM sys.indexes i
INNER JOIN sys.filegroups f
ON i.data_space_id = f.data_space_id
INNER JOIN sys.all_objects o
ON i.[object_id] = o.[object_id] WHERE i.data_space_id = f.data_space_id AND o.type = 'U'

--attempt to populate table in empty filegroup (fail)
INSERT INTO MyReadOnlyTable VALUES('Jimmy','Butler','jimmybutler@miamiheat.com')

--attempt to make empty filegroup readonly (fail)
ALTER DATABASE [AdventureWorksLT2022] MODIFY FILEGROUP [ReadOnlyFG1] READONLY;


USE AdventureWorksLT2022;
GO
-- STEP 1 Adds four new filegroups to the AdventureWorksLT2022 database
ALTER DATABASE AdventureWorksLT2022
ADD FILEGROUP test1fg;
GO
ALTER DATABASE AdventureWorksLT2022
ADD FILEGROUP test2fg;
GO
ALTER DATABASE AdventureWorksLT2022
ADD FILEGROUP test3fg;
GO
ALTER DATABASE AdventureWorksLT2022
ADD FILEGROUP test4fg;

-- STEP 2 Adds one file for each filegroup.
-- Please create a folder in C:Drive called as DATA
ALTER DATABASE AdventureWorksLT2022
ADD FILE
(
NAME = test1dat1,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\t1dat1.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB
)
TO FILEGROUP test1fg;
ALTER DATABASE AdventureWorksLT2022
ADD FILE
(
NAME = test2dat2,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\t2dat2.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB
)
TO FILEGROUP test2fg;
GO
ALTER DATABASE AdventureWorksLT2022
ADD FILE
(
NAME = test3dat3,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\t3dat3.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB
)
TO FILEGROUP test3fg;
GO
ALTER DATABASE AdventureWorksLT2022
ADD FILE
(
NAME = test4dat4,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\t4dat4.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB
)
TO FILEGROUP test4fg;
GO

--Display all filegroups in database
USE AdventureWorksLT2022;
SELECT * FROM sys.filegroups;
GO

--Task 6: Performs a query on a table's indexes for fragmentation percentage
USE AdventureWorksLT2022;
SELECT
    a.index_id,
    b.name AS index_name,
    a.avg_fragmentation_in_percent
FROM
    sys.dm_db_index_physical_stats(DB_ID(N'AdventureWorksLT2022'),
                                    OBJECT_ID(N'SalesLT.Address'), 
                                    NULL, 
                                    NULL, 
                                    NULL) AS a 
JOIN
    sys.indexes AS b
ON
    a.object_id = b.object_id AND a.index_id = b.index_id;
GO

--Task 6.1 Reorganize two indexes
USE AdventureWorksLT2022;
ALTER INDEX PK_Address_AddressID
ON
SalesLT.Address
REORGANIZE;
GO 

USE AdventureWorksLT2022;
ALTER INDEX IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion
ON
SalesLT.Address
REORGANIZE;
GO

--Task 6.2 Rebuild two indexes
USE AdventureWorksLT2022;
ALTER INDEX AK_Address_rowguid
ON
SalesLT.Address
REBUILD;
GO 

USE AdventureWorksLT2022;
ALTER INDEX IX_Address_StateProvince
ON
SalesLT.Address
REBUILD;
GO

--task 7 Backup database 
BACKUP DATABASE AdventureWorksLT2022
TO DISK = 'D:\SQL\AdventureWorksLT2022Backup.bak'

--task 7 Leave database prior to restore
USE master;
GO

--Task 8 create tables
USE AdventureWorksLT2022
GO
CREATE TABLE [dbo].[orders](
[orderid] [int] NOT NULL,
[amount] [bigint] NULL,
[customer] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[customers](
[customerId] [int] NOT NULL,
[firstname] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
--Task 8 populate tables
USE AdventureWorksLT2022
GO
INSERT INTO AdventureWorksLT2022.dbo.orders(orderid,amount,customer)
VALUES (640,5,1);
INSERT INTO AdventureWorksLT2022.dbo.orders(orderid,amount,customer)
VALUES (641,9,2);
INSERT INTO AdventureWorksLT2022.dbo.orders(orderid,amount,customer)
VALUES (642,14,3);
INSERT INTO AdventureWorksLT2022.dbo.customers(customerId,firstname)
VALUES (1,'Catherina Zhang');
INSERT INTO AdventureWorksLT2022.dbo.customers(customerId,firstname)
VALUES (2,'Allen Barbarosa');
INSERT INTO AdventureWorksLT2022.dbo.customers(customerId,firstname)
VALUES (4,'Debbie M"Lady');
--Task 8 Inner Join
USE AdventureWorksLT2022
GO
SELECT C.customerId, C.firstname, O.amount
FROM dbo.customers as C 
JOIN dbo.orders as O
ON C.customerId = o.customer;
--Task 8 Full Outer Join
USE AdventureWorksLT2022
GO
SELECT C.customerId, C.firstname, O.amount
FROM dbo.customers as C 
FULL OUTER JOIN dbo.orders as O
ON C.customerId = o.customer;
--Task 8 Left Outer Join
USE AdventureWorksLT2022
GO
SELECT C.customerId, C.firstname, O.amount
FROM dbo.customers as C 
LEFT JOIN dbo.orders as O
ON C.customerId = o.customer;
--Task 8 Right Outer Join
USE AdventureWorksLT2022
GO
SELECT C.customerId, C.firstname, O.amount
FROM dbo.customers as C 
RIGHT JOIN dbo.orders as O
ON C.customerId = o.customer;