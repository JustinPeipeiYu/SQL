/*
use TestOct5
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

CREATE TABLE [dbo].[users](
    [Id] [int] NULL,
    [name] [nchar](10) NULL,
    [course] [nchar](10) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[course](
    [Id] [int] NOT NULL,
    [name] [nchar](10) NULL
) ON [PRIMARY]
GO


Insert into orders values (1,200, 1);
Insert into orders values (2,500, 2);
Insert into orders values (3,800, 3);

INSERT INTO customers values (1, 'ABC')
INSERT INTO customers values (2, 'XYZ')

-- Insert few values into user and course table
INSERT INTO users values (1, 'Alice', 'DB systems')
INSERT INTO users values (2, 'Bob', 'Comp 1225')
INSERT INTO users values (3, 'Charles', 'INFO 1234')

INSERT INTO course values (1, 'INFO 1234')
INSERT INTO course values (2, 'COMP 1225')
INSERT INTO course values (3, 'AIML 1234')
INSERT INTO course values (4, 'DATA 1234')

select * from users;
Select * from course;
Select * from orders;
Select * from customers;
*/

-- Operator manipulations
Select * from customers where customerid > 2
Select * from customers where customerid >= 2
Select * from customers where customerid < 2
Select * from customers where customerid <= 2
Select * from customers where customerid <> 2 -- not equal to

-- String Concatenation (Join two or more words)
Select * from customers;
Update customers
set firstname = 'Betty' + 'Smith'
where customerid = 2
Select * from customers;

-- Logical manipulations
-- NOT same Not Equal
-- AND
Select * from users
select * from users where id = 1 and id = 2 -- no results as there is no id like 1 and 2 or
select * from users where id = 1 or id = 2
-- between
Select * from orders
Select * from orders where amount between 100 and 600
-- Like %
Select * from customers
Select * from customers where firstname like 'a%'
-- NULL
Select * from users
Select * from users where course = '';
-- Not Null
Select * from users where course != '';

--String functions
Select * from course;
select len(name) as length from course where id =1;

-- Aggegrate function min max avg, count
Select count(*) from course;
Select * from orders
Select min(amount) from orders
Select max(amount) from orders
Select sum(amount) from orders
Select AVG(amount) from orders

-- order by
select * from course
order by id desc

Select * from users
Select count(*), course from users
group by course

-- For Joins
-- Inner Joins
-- use alias C for Customers table
-- use alias O for Orders table
Select * from customers;
Select * from orders;
SELECT C.customerId, C.firstname, O.amount
FROM Customers AS C
JOIN Orders AS O
ON C.customerId = O.customer;

-- full join Customers and Orders tables
-- based on their shared customer_id columns
-- Customers is the left table
-- Orders is the right table

SELECT Customers.customerid, Customers.firstname, Orders.amount
FROM Customers
FULL OUTER JOIN Orders
ON Customers.customerid = Orders.customer;

select * from users;
Select * from course;

-- inner join [common elements]
SELECT users.name, course.name FROM users INNER JOIN course on users.id = course.id;
SELECT users.name, course.name FROM users JOIN course on users.id = course.id;
-- Left Join
SELECT users.name, course.name FROM users LEFT JOIN course on users.id = course.id;
--RIGHT
SELECT users.name, course.name FROM users RIGHT JOIN course on users.id = course.id;
--OUTER
SELECT users.name, course.name FROM users Full OUTER JOIN course on users.id = course.id; 