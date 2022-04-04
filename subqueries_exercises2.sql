USE employees;
-- 1) Find all the current employees with the same hire date as employee 101010 using a sub-query.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date IN (SELECT hire_date
					FROM employees
                    WHERE emp_no = '101010');
                    
-- 2) Find all the titles ever held by all current employees with the first name Aamod.
SELECT *
FROM titles
WHERE emp_no in (SELECT emp_no
					FROM employees
					WHERE first_name = 'Aamod')
AND to_date >= NOW();

-- 3) How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.
SELECT Count(*)
FROM employees
WHERE emp_no NOT IN (SELECT emp_no
					FROM dept_emp
					WHERE to_date < NOW()
					);

-- 4) Find all the current department managers that are female. List their names in a comment in your code.
SELECT CONCAT(first_name, ' ', last_name) as full_name
FROM dept_manager dm
JOIN employees e
	ON e.emp_no=dm.emp_no
WHERE to_date > NOW()
AND dm.emp_no IN (SELECT emp_no
				FROM employees
                WHERE gender = 'F'
                );

-- 5) Find all the employees who currently have a higher salary than the companies overall, historical average salary.
SELECT DISTINCT(s.emp_no), first_name, last_name, salary, to_date
FROM salaries s
JOIN employees e
	ON s.emp_no=e.emp_no
WHERE salary > (
				SELECT AVG(salary) as avg_sal_historical
				FROM salaries
                )
AND s.to_date > NOW();

-- 6) How many current salaries are within 1 standard deviation of the current highest salary? 
-- (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?
-- Hint Number 1 You will likely use a combination of different kinds of subqueries.
-- Hint Number 2 Consider that the following code will produce the z score for current salaries.
/* Returns the historic z-scores for each salary
-- Notice that there are 2 separate scalar subqueries involved
SELECT salary,
    (salary - (SELECT AVG(salary) FROM salaries))
    /
    (SELECT stddev(salary) FROM salaries) AS zscore
FROM salaries; */

-- BONUS

-- Find all the department names that currently have female managers.
-- Find the first and last name of the employee with the highest salary.
-- Find the department name that the employee with the highest salary works in.