-- 1. Use the employees database

USE employees;

-- 2. Using the example in the Associative Table Joins section as a guide, 
-- write a query that shows each department along with the name of the current manager for that
-- department

/*SELECT ed.dept_name AS 'Department Name', 
		CONCAT(ed.first_name, ' ', ed.last_name) 
		AS 'Department Manager'
FROM employees_with_departments 
		AS ed
JOIN dept_manager 
	AS dm 
	ON dm.emp_no = ed.emp_no 
	AND dm.to_date > CURDATE();
	
	...bad code :/ */

SELECT  d.dept_name, CONCAT(e.first_name, ' ', e.last_name) AS full_name
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
JOIN departments AS d
  ON d.dept_no = de.dept_no
JOIN dept_manager AS dm
  ON e.emp_no = dm.emp_no
  AND dm.to_date > CURDATE()
 ORDER BY d.dept_name;
 
SELECT dept_name, first_name, last_name
FROM departments
JOIN dept_manager
  ON dept_manager.dept_no = departments.dept_no
JOIN employees
  ON employees.emp_no = dept_manager.emp_no
 WHERE dept_manager.to_date > CURDATE();
 

-- 3. Find the name of all departments currently managed by women.

SELECT  d.dept_name, CONCAT(e.first_name, ' ', e.last_name) AS manager_name
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
JOIN departments AS d
  ON d.dept_no = de.dept_no
JOIN dept_manager AS dm
  ON e.emp_no = dm.emp_no
  AND dm.to_date > CURDATE()
 WHERE gender = 'f'
 ORDER BY d.dept_name;

-- 4. Find the current titles of employees currently working in the Customer Service department.

SELECT t.title AS title, COUNT(t.title) AS count
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
  AND de.to_date >CURDATE()
JOIN departments AS d
  ON d.dept_no = de.dept_no
JOIN titles AS t
  ON t.emp_no = e.emp_no
  AND t.to_date > CURDATE()
 WHERE d.dept_name = "Customer Service"
 GROUP BY t.title;
 
 -- 5. Find the current salary of all current managers
 
SELECT d.dept_name AS dept_name, 
		CONCAT(e.first_name, ' ', e.last_name) AS full_name, 
		s.salary AS salary
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
JOIN departments AS d
  ON d.dept_no = de.dept_no
JOIN salaries AS s
  ON s.emp_no = e.emp_no
  AND s.to_date > CURDATE()
JOIN dept_manager AS dm
  ON dm.emp_no = e.emp_no
  AND dm.to_date > CURDATE()
 GROUP BY dept_name, full_name, salary;
 
 -- 6. Find the number of employees in each department. (to date)

SELECT de.dept_no AS dept_no, d.dept_name AS dept_name, COUNT(de.emp_no) AS num_employees
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
  AND de.to_date > CURDATE()
JOIN departments AS d
  ON d.dept_no = de.dept_no
GROUP BY de.dept_no;

-- 7. Which department has the highest average salary?

SELECT d.dept_name AS dept_name, (AVG(s.salary)) AS average_salary
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
  AND de.to_date > CURDATE()
JOIN departments AS d
  ON d.dept_no = de.dept_no
JOIN salaries AS s
  ON e.emp_no = s.emp_no
  AND s.to_date > CURDATE()
GROUP BY d.dept_name
ORDER BY average_salary DESC
LIMIT 1;

-- 8. Who is the highest paid employee in the Marketing department?

SELECT e.first_name AS first_name, e.last_name AS last_name
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
  AND de.to_date > CURDATE()
JOIN departments AS d
  ON d.dept_no = de.dept_no
JOIN salaries AS s
  ON e.emp_no = s.emp_no
  AND s.to_date > CURDATE()
ORDER BY d.dept_no, s.salary DESC
LIMIT 1;

-- 9. Which current department manager has the highest salary?

SELECT e.first_name AS first_name, e.last_name AS last_name, s.salary AS salary, d.dept_name AS dept_name
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
JOIN departments AS d
  ON d.dept_no = de.dept_no
JOIN salaries AS s
  ON s.emp_no = e.emp_no
  AND s.to_date > CURDATE()
JOIN dept_manager AS dm
  ON dm.emp_no = e.emp_no
  AND dm.to_date > CURDATE()
ORDER BY s.salary DESC
LIMIT 1;
  
-- 10. BONUS Find the names of all current employees, their department name, and their current manager's name

-- 240,124 Rows

-- Employee Name | Department Name  |  Manager Name
-- --------------|------------------|-----------------
-- Huan Lortz   | Customer Service | Yuchang Weedman
-- .....

-- BREAKDOWN
-- 1. Get all employees who are currently in a department (dept_emp, currently -> filter to_date)
-- 2. Get their name (employees)
-- 3. get their deparment name (departments)
-- 4. and add the current manager of each dept(dept_manager) (departments)
-- 5. tie to current managers to employees database

-- 1
SELECT de.emp_no, de.dept_no, 
FROM dept_emp AS de
WHERE de.to_date > CURDATE();

-- 2 get emp names
SELECT de.emp_no, e.emp_no, de.dept_no, e.first_name, e.last_name
FROM dept_emp AS de
JOIN employees AS e 
	ON de.emp_no = e.emp_no
WHERE de.to_date > CURDATE();

-- 3 get dept names
SELECT de.emp_no, de.dept_no, e.first_name, e.last_name, d.dept_name
FROM dept_emp AS de
JOIN employees AS e 
	ON de.emp_no = e.emp_no
JOIN departments AS d
	ON de.dept_no = d.dept_no
WHERE de.to_date > CURDATE();

-- 4 get current manager of each dept
SELECT dm.emp_no, dm.dept_no
FROM dept_manager AS dm
WHERE dm.to_date > CURDATE();

-- 5 tie manger dpet with emp dept
 SELECT de.emp_no
 		, de.dept_no
 		, e.first_name
 		, e.last_name
 		, d.dept_name
 		, dm.emp_no AS mgr_emp
FROM dept_emp AS de
JOIN employees AS e 
	ON de.emp_no = e.emp_no
JOIN departments AS d
	ON de.dept_no = d.dept_no
JOIN dept_manager AS dm
	ON de.dept_no = dm.dept_no
	AND dm.to_date > CURDATE()
WHERE de.to_date > CURDATE();


-- 6 get managers name
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name
 		, d.dept_name AS dept_name
 		, CONCAT(ee.first_name, ' ', ee.last_name) AS manger_name
FROM dept_emp AS de
JOIN employees AS e 
	ON de.emp_no = e.emp_no
JOIN departments AS d
	ON de.dept_no = d.dept_no
JOIN dept_manager AS dm
	ON de.dept_no = d.dept_no
	AND dm.to_date > CURDATE()
JOIN employees AS ee 
	ON dm.emp_no = ee.emp_no
WHERE de.to_date > CURDATE();
 
-- 11. Bonus Find the highest paid employee in each department.




