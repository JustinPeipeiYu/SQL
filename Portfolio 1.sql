ALTER DATABASE AdventureWorksLT2022
ADD FILEGROUP ReadOnlyFG1;
GO
--Create a table on the filegroup
CREATE TABLE AdventureWorksLT2022.dbo.MyReadOnlyTable
( FirstName varchar(50),
LastName varchar(50),
EMailAddress char(1000) )
ON ReadOnlyFG1;
-- Show the output of above executed scripts
--Please use any of the AdventureWorksLT2022 tables and perform CRUD operations on it

--attempt to populate table 
INSERT INTO MyReadOnlyTable VALUES('Jimmy','Butler','jimmybutler@miamiheat.com')

--Display three tables
SELECT * FROM sys.indexes
SELECT * FROM sys.filegroups
SELECT * FROM sys.all_objects

--displays which filegroup the objects are in
USE AdventureWorksLT2022
SELECT o.[name], o.[type], f.[name] FROM sys.indexes i
--join filegroups database to indexes database
INNER JOIN sys.filegroups f
ON i.data_space_id = f.data_space_id
--join to objects database
INNER JOIN sys.all_objects o
--filter for user-created objects from filegroups database
ON i.[object_id] = o.[object_id] WHERE i.data_space_id = f.data_space_id AND o.type = 'U'



--Try to make the filegroup readonly
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

--Performs a query on indexes tables for fragmentation percentage
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