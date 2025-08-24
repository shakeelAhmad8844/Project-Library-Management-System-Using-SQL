# Library Management Systems Project

## Project Overview

**Project Title**: Library Management Systems  
**Level**: Intermediate  
**Database**: `library_project`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/shakeelAhmad8844/Project-Library-Management-System-Using-SQL/blob/8a07043f7f0175fd2e38a70ecfab917228d8e5c4/ERD_Library_MS.png)

- **Database Creation**: Created a database named `library_project`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_project;

-- Books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books 
(
            isbn varchar(20) primary key,
            book_title varchar(60),
            category varchar(10),
            rental_price float,
            status varchar(10),
            author varchar(35),
            publisher varchar(50)

);


-- Create table "Employee"
-- employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id varchar(25) primary key,
            emp_name varchar(25),
            position varchar(20),
            salary int,
            branch_id varchar(25)  -- fk

);


-- Create table "Members"
-- Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members 
(
            member_id varchar(12) primary key,
            member_name varchar(35),
            member_address varchar(35),	
            reg_date date
);


-- Create Tables
-- Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id varchar(10) primary key,
            manager_id varchar(12),
            branch_address varchar(60),
            contact_no varchar(15)
);


-- Issued_status Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id varchar(12) primary key,
            issued_member_id varchar(10),      -- fk
            issued_book_name varchar(35),
            issued_date date,
            issued_book_isbn varchar(25),     -- fk
            issued_emp_id varchar(10)             -- fk
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id varchar(10) primary key,
            issued_id varchar(12),      -- fk
            return_book_name varchar(70),
            return_date	date, 
            return_book_isbn varchar(20)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT 
    m.member_id,
    m.member_name,
    COUNT(i.issued_id) AS total_books_issued
FROM members m
JOIN issued_status i ON m.member_id = i.issued_member_id
GROUP BY m.member_id, m.member_name
HAVING COUNT(i.issued_id) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issued_summary AS
SELECT 
    b.isbn,
    b.book_title,
    COUNT(i.issued_id) AS book_issued_cnt
FROM 
    books b
LEFT JOIN 
    issued_status i ON b.isbn = i.issued_book_isbn
GROUP BY 
    b.isbn, b.book_title;
    
select * from book_issued_summary;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT
    b.category,
    SUM(b.rental_price) AS total_rental_income,
    COUNT(*) as category_wised_issued
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT 
    member_id,
    member_name,
    member_address,
    reg_date
FROM 
    members
WHERE 
    reg_date >= CURDATE() - INTERVAL 180 DAY; 


INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C118', 'sam', '145 Main St', '2025-03-01'),
('C119', 'john', '133 Main St', '2025-04-01');
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
    e.emp_id AS employee_id,
    e.emp_name AS employee_name,
    b.branch_id,
    b.branch_address,
    b.contact_no,
    m.emp_name AS branch_manager_name
FROM 
    employees e
JOIN 
    branch b ON e.branch_id = b.branch_id
JOIN 
    employees m ON b.manager_id = m.emp_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE Special_books
AS    
SELECT * FROM Books
WHERE rental_price > 7;

select * from Special_books;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
    i.issued_id,
    i.issued_book_isbn,
    b.book_title,
    i.issued_member_id,
    m.member_name,
    i.issued_date
FROM 
    issued_status i
JOIN 
    books b ON i.issued_book_isbn = b.isbn
JOIN 
    members m ON i.issued_member_id = m.member_id
LEFT JOIN 
    return_status r ON i.issued_id = r.issued_id
WHERE 
    r.issued_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
    i.issued_member_id AS member_id,
    m.member_name,
    b.book_title,
    i.issued_date,
    DATEDIFF(CURDATE(), i.issued_date) AS days_overdue
FROM 
    issued_status i
JOIN 
    members m ON i.issued_member_id = m.member_id
JOIN 
    books b ON i.issued_book_isbn = b.isbn
LEFT JOIN 
    return_status r ON i.issued_id = r.issued_id
WHERE 
    r.return_id IS NULL                     -- book not returned
    AND DATEDIFF(CURDATE(), i.issued_date) > 30;   -- overdue

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
    
SELECT * FROM return_status;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql
SELECT * FROM books
WHERE isbn = '978-0-451-52994-2';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-330-25864-8';

UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2';

SELECT * FROM return_status
WHERE issued_id = 'IS130';

INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
VALUES
('RS125', 'IS130', CURRENT_DATE, 'Good');

SELECT * FROM return_status
WHERE issued_id = 'IS130';

-- Stored Procedure to Handle Book Returns:

DELIMITER //

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(12),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- Get ISBN and Book Name from issued_status
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Insert return record
    INSERT INTO return_status(
        return_id,
        issued_id,
        return_book_name,
        return_date,
        return_book_isbn,
        book_quality
    )
    VALUES (
        p_return_id,
        p_issued_id,
        v_book_name,
        CURRENT_DATE(),
        v_isbn,
        p_book_quality
    );

    -- Update the status of the book to 'Yes'
    UPDATE books
    SET status = 'Yes'
    WHERE isbn = v_isbn;

    -- Show confirmation
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
END //

DELIMITER ;

-- Sample Call to the Procedure
CALL add_return_records('RS138', 'IS135', 'Good');
CALL add_return_records('RS148', 'IS140', 'Good');

--  Check Results
-- See book status updated
SELECT * FROM books WHERE isbn = '978-0-307-58837-1';

-- See inserted return status
SELECT * FROM return_status WHERE issued_id = 'IS135';

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(i.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as i
JOIN 
employees as e
ON e.emp_id = i.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = i.issued_id
JOIN 
books as bk
ON i.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branch_reports;
```

**Task 16: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
    e.emp_name,
    b.*,
    COUNT(i.issued_id) as no_book_issued
FROM issued_status as i
JOIN
employees as e
ON e.emp_id = i.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2;
```


## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


## Author - Engineer Shakeel Ahmad

This project showcases SQL skills essential for database management and analysis. For more content on SQL and data analysis, connect with me through the following channels:

- **Email**: shakeelshaheensss@gmail.com
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/shakeel-ahmad-506593233)

Thank you for your interest in this project!
