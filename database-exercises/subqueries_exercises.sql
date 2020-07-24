# 1. Find all the employees with the same hire date as employee 101010 using a sub-query
# 69 Rows
SELECT first_name, last_name #display the employee names columns
FROM employees				 #from the employees table
WHERE hire_date IN ( 		 #filter results to when the hire date is in
	SELECT hire_date		 #the hire date
	FROM employees			 #from employees table
	WHERE emp_no = 101010	 #that is the same as employee 101010
);

# 2. Find all the titles held by all employees with the first name Aamod.
# 314 total titles
SELECT title
FROM titles
WHERE emp_no IN (
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Aamod'
);

# 6 unique titles
SELECT title
FROM titles
WHERE emp_no IN (
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Aamod'
)
GROUP BY title;
