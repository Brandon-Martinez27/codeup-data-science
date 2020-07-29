-- 1. Find all the employees with the same hire date as employee 101010 using a sub-query
-- 69 Rows

USE employees;
SELECT first_name, last_name --display the employee names columns
FROM employees				 --from the employees table
WHERE hire_date IN ( 		 --filter results to when the hire date is in
	SELECT hire_date		 --the hire date
	FROM employees			 --from employees table
	WHERE emp_no = 101010	 --that is the same as employee 101010
);

-- 2. Find all the titles held by all employees with the first name Aamod.
-- 314 total titles
SELECT title
FROM titles
WHERE emp_no IN (
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Aamod'
);

-- '6' unique titles
SELECT title
FROM titles
WHERE emp_no IN (
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Aamod'
)
GROUP BY title;


-- 3. How many people in the employees table are no longer working for the company?
-- WRONG
SELECT COUNT(DISTINCT emp_no) as no_longer_working
FROM dept_emp
WHERE emp_no IN (
	SELECT DISTINCT emp_no
	FROM employees
)
AND to_date <= CURDATE();

--CORRECT
SELECT COUNT(*)
FROM employees
WHERE emp_no NOT IN (
	SELECT emp_no 
	FROM dept_emp
	WHERE to_date > CURDATE()
);

-- 4. Find all the current department managers that are female.

SELECT first_name, last_name
FROM employees
WHERE gender = 'f'
  AND emp_no IN (
	SELECT emp_no
	FROM dept_manager
	WHERE to_date > CURDATE()
);

-- 5. Find all the employees that currently have a higher than average salary.
-- 154543 rows in total. 

SELECT e.first_name, e.last_name, s.salary
FROM (
	SELECT AVG(salary) as avg_sal
	FROM salaries
) as avg_s
JOIN employees as e 
JOIN salaries as s 
	ON s.emp_no = e.emp_no 
WHERE s.to_date > CURDATE()
AND s.salary > avg_s.avg_sal;

-- 6. How many current salaries are within 1 standard deviation of the highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this? 78 salaries

SELECT COUNT(s.salary)
FROM (
	SELECT STDDEV(salary) as sd_sal
	FROM salaries
) as sd_s
JOIN (
	SELECT MAX(salary) as max_sal
	FROM salaries
) as max_s
JOIN (
	SELECT AVG(salary) as avg_sal
	FROM salaries
) as avg_s
JOIN salaries as s
WHERE s.to_date > CURDATE()
AND max_s.max_sal - sd_s.sd_sal <= s.salary;

-- What percentage of salaries

-- BONUS
-- 1. Find all the department names that currently have female managers
SELECT dept_name
FROM departments as d
JOIN dept_emp as de
  ON de.dept_no = d.dept_no
JOIN employees as e
  ON e.emp_no = de.emp_no
WHERE e.emp_no IN (
	SELECT emp_no
	FROM employees
	WHERE gender = 'f'
  	AND emp_no IN (
		SELECT emp_no
		FROM dept_manager
		WHERE to_date > CURDATE()
));

-- 2. Find the first and last name of the employee with the highest salary.

SELECT first_name, last_name
FROM employees AS e
JOIN salaries AS s
  ON s.emp_no = e.emp_no
JOIN (
	SELECT MAX(salary) as max_column
	FROM salaries
) AS max_table
WHERE max_table.max_column = s.salary
;

-- 3. Find the department name that the employee with the highest salary works in

SELECT d.dept_name
FROM employees AS e
JOIN salaries AS s
  ON s.emp_no = e.emp_no
JOIN (
	SELECT MAX(salary) as max_column
	FROM salaries
) AS max_table
JOIN dept_emp as de
  ON de.emp_no = e.emp_no
JOIN departments as d
  ON d.dept_no = de.dept_no
WHERE max_table.max_column = s.salary;
