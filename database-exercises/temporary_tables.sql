USE darden_1039;

-- 1. Using the example from the lesson, re-create the employees_with_departments table
CREATE TEMPORARY TABLE employees_with_departments AS
SELECT e.emp_no, e.first_name, e.last_name, de.dept_no, d.dept_name
FROM employees.employees AS e
JOIN employees.dept_emp AS de
	USING(emp_no) 
JOIN employees.departments AS d
	USING(dept_no)
LIMIT 100;

-- checking that table was created
SELECT *
FROM employees_with_departments;

-- 1a. Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns

ALTER TABLE employees_with_departments
ADD full_name VARCHAR(100);

--checking that column was added

SELECT *
FROM employees_with_departments;

-- 1b. Update the table so that full name column contains the correct data

UPDATE employees_with_departments
SET full_name = CONCAT(first_name, ' ', last_name);

SELECT *
FROM employees_with_departments;

-- 1c. Remove the first_name and last_name columns from the table.

ALTER TABLE employees_with_departments
DROP COLUMN first_name;

SELECT *
FROM employees_with_departments;

ALTER TABLE employees_with_departments
DROP COLUMN last_name;

SELECT *
FROM employees_with_departments;

-- 1d. What is another way you could have ended up with this same table?
-- A: concatenate the first and last name when you created the temp table with full name as an alias

-- 2. Create a temporary table based on the payment table from the sakila database.
USE darden_1039;
CREATE TEMPORARY TABLE payment AS
SELECT sp.payment_id, 
	   sp.customer_id, 
	   sp.staff_id, 
	   sp.rental_id, 
	   sp.amount, 
	   sp.payment_date, 
	   sp.last_update
FROM sakila.payment AS sp;

SELECT * 
FROM payment;

-- Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199

DESCRIBE payment;

ALTER TABLE payment
ADD amount_int INT(10);

SELECT * 
FROM payment;

UPDATE payment
SET amount_int = amount * 100;

SELECT * 
FROM payment;

-- 3. Find out how the average pay in each department compares to the overall average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department to work for? The worst

USE darden_1039;

-- Average Salary in each dept as a temp table
CREATE TEMPORARY TABLE average_salary_dept AS
SELECT d.dept_name, AVG(s.salary) AS ads
FROM employees.salaries AS s
JOIN employees.dept_emp AS de 
	USING(emp_no)
JOIN employees.departments AS d 
	USING(dept_no)
WHERE s.to_date > CURDATE()
AND de.to_date > CURDATE()
GROUP BY d.dept_name;

SELECT *
FROM average_salary_dept;

-- Average total salary
CREATE TEMPORARY TABLE average_total_salary AS
SELECT AVG(s.salary) as av
FROM employees.salaries as s
WHERE to_date > CURDATE();

SELECT *
FROM average_total_salary;

-- Standard Dev for all salaries
CREATE TEMPORARY TABLE stdev_salary AS
SELECT STDDEV(s.salary) as sd
FROM employees.salaries as s
WHERE s.to_date > CURDATE();

SELECT *
FROM stdev_salary;

-- Z-Score for each dept
SELECT dept_name, (ads - av)/sd
FROM average_salary_dept
JOIN average_total_salary
JOIN stdev_salary;