-- 1. Write a query that returns all employees (emp_no), their department number, their start date, their end date, and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not

/* tables needed: dept_emp(emp_no, dept_no, to_date), 
 				  employees(hire)
   JOIN both tables USING emp_no
   CASE WHEN to_date is >= CURDATE
*/

USE employees;

SELECT DISTINCT emp_no
	, dept_no
	, hire_date
	, to_date
	, CASE WHEN to_date > CURDATE() THEN 1 
		ELSE 0 
		END AS is_current_employee
FROM dept_emp
JOIN employees as e
	USING(emp_no)
;

-- 2. Write a query that returns all employee names, and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.

SELECT first_name
	   , last_name
	   , CASE 
	   		WHEN last_name LIKE 'a%'
	   			OR last_name LIKE 'b%'
	   			OR last_name LIKE 'c%'
	   			OR last_name LIKE 'd%'
	   			OR last_name LIKE 'e%'
	   			OR last_name LIKE 'f%'
	   			OR last_name LIKE 'g%'
	   			OR last_name LIKE 'h%' THEN "A-H"
	   		WHEN last_name LIKE 'i%'
	   			OR last_name LIKE 'j%'
	   			OR last_name LIKE 'k%'
	   			OR last_name LIKE 'l%'
	   			OR last_name LIKE 'm%'
	   			OR last_name LIKE 'n%'
	   			OR last_name LIKE 'o%'
	   			OR last_name LIKE 'p%' 
	   			OR last_name LIKE 'q%' THEN "I-Q"
	   		WHEN last_name LIKE 'r%'
	   			OR last_name LIKE 's%'
	   			OR last_name LIKE 't%'
	   			OR last_name LIKE 'u%'
	   			OR last_name LIKE 'v%'
	   			OR last_name LIKE 'w%'
	   			OR last_name LIKE 'x%'
	   			OR last_name LIKE 'y%' 
	   			OR last_name LIKE 'z%' THEN "R-Z"
	   		ELSE null
	   		END AS alpha_group
FROM employees;

-- 3. How many employees were born in each decade?
SELECT CASE WHEN birth_date LIKE '195%' THEN 'Born in the 50s'
	   		WHEN birth_date LIKE '196%-%-%' THEN 'Born in the 60s'
	   		ELSE null
	   		END AS OK_BOOMERS
	   		, COUNT(emp_no) AS old_timers
FROM employees
GROUP BY OK_BOOMERS;

-- BONUS

-- 1. What is the average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
/*
+-------------------+-----------------+
| dept_group        | avg_salary      |
+-------------------+-----------------+
| Customer Service  |                 |
| Finance & HR      |                 |
| Sales & Marketing |                 |
| Prod & QM         |                 |
| R&D               |                 |
+-------------------+-----------------+
*/

-- tables needed: salaries(AVG(salary)), departments, dept_emp (link emp_no to salaries)
-- show dept names and average salaries
-- combine deparment names and their average salaries
-- show the combined dept names with repsective combined average salaries

SELECT dept_name
	   , AVG(salary)
FROM dept_emp
JOIN departments
	USING(dept_no)
JOIN salaries
	USING(emp_no)
GROUP BY dept_name;

SELECT CASE WHEN dept_name = 'Finance' AND dept_name = 'Human Resources' THEN 
	   , dept_name
	   , AVG(salary)
FROM dept_emp
JOIN departments
	USING(dept_no)
JOIN salaries
	USING(emp_no)
GROUP BY dept_name;
