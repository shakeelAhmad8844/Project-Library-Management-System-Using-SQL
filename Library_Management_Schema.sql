-- Library Management Systems Project
-- AUthor : Engineer Shakeel Ahmad

use library_project;

-- Create Tables
-- Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
branch_id varchar(10) primary key,
manager_id varchar(12),
branch_address varchar(60),
contact_no varchar(15)
);

-- Books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books (
isbn varchar(20) primary key,
book_title varchar(60),
category varchar(10),
rental_price float,
status varchar(10),
author varchar(35),
publisher varchar(50)

);

alter table books
modify column category  varchar(50);


-- employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
emp_id varchar(25) primary key,
emp_name varchar(25),
position varchar(20),
salary int,
branch_id varchar(25)  -- fk

);

-- Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members (
member_id varchar(12) primary key,
member_name varchar(35),
member_address varchar(35),	
reg_date date
);

-- Issued_status Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
issued_id varchar(12) primary key,
issued_member_id varchar(10),      -- fk
issued_book_name varchar(35),
issued_date date,
issued_book_isbn varchar(25),     -- fk
issued_emp_id varchar(10)             -- fk
);

alter table issued_status
modify column issued_book_name varchar(80);


-- Return_status Table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
return_id varchar(10) primary key,
issued_id varchar(12),      -- fk
return_book_name varchar(70),
return_date	date, 
return_book_isbn varchar(20)
);


-- foreign key
 ALTER TABLE issued_status
ADD CONSTRAINT fk_members
foreign key (issued_member_id)
REFERENCES members( member_id );

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
foreign key (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
foreign key (issued_emp_id)
REFERENCES employees(emp_id );

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status 
foreign key (issued_id)
REFERENCES issued_status(issued_id );

ALTER TABLE employees
ADD CONSTRAINT fk_branch 
foreign key (branch_id)
REFERENCES branch(branch_id);

