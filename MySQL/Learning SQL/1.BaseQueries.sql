SELECT emp_id,
       'ACTIVE',
       emp_id * 3.14159,
       UPPER(lname)
FROM employee;

SELECT VERSION(),
       USER(),
       DATABASE();

SELECT emp_id,
       'ACTIVE' status,
       emp_id * 3.14159 empid_x_pi,
       UPPER(lname) last_name_upper
FROM employee;


SELECT cust_id
FROM account;

# Distinct delete duplicates,
# but in require sort of data.
# Be accurate with big data

SELECT DISTINCT cust_id
FROM account;

# Simple subquery
SELECT e.emp_id, e.fname, e.lname
FROM (
  SELECT emp_id, fname, lname,
         start_date, title
  FROM employee) e;

# View create new virtual table
CREATE VIEW employee_vw AS
  SELECT emp_id, fname, lname,
         YEAR(start_date) start_year
FROM employee;

SELECT *
FROM employee;

SELECT *
FROM employee_vw;

# When you add value into table, view updating also
INSERT INTO employee (emp_id, fname, lname, start_date, end_date, superior_emp_id, dept_id, title, assigned_branch_id)
  VALUES (NULL, 'Sergey',  'Sidorov',	'2001-06-22', NULL, 3, 3,	'President' ,	1);

SELECT *
FROM employee;

SELECT *
FROM employee_vw;

# Simple join
SELECT e.emp_id, e.fname, e.lname, d.name dept_name
FROM employee e INNER JOIN department d
ON e.dept_id = d.dept_id;

# Simple where
SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE title = 'Head Teller';

SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE title = 'Head Teller'
AND start_date > '2002-01-01'
ORDER BY start_date;

SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE title = 'Head Teller'
OR start_date > '2002-01-01'
ORDER BY start_date;

SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE (title = 'Head Teller' AND start_date > '2002-01-01')
      OR (title = 'Teller' AND start_date > '2003-01-01')
ORDER BY title, start_date;

# sort with expressions
SELECT cust_id, cust_type_cd, city, state, fed_id
FROM customer
ORDER BY RIGHT(fed_id, 3); # ordered by last 3 digits fed_id

# you can ordering by number of select columns
SELECT emp_id, title, start_date, fname, lname
FROM employee
ORDER BY 2, 5; # ordered by title and lname

DROP VIEW employee_vw;

# HOMEWORK
# 3.1 select id, fname and lname all employees with order by lname and fname
SELECT emp_id, fname, lname
FROM employee
ORDER BY lname, fname;

# 3.2 https://cl.ly/3ba68da29fb7
DESC account;

SELECT account_id, cust_id, avail_balance
FROM account
WHERE status = 'ACTIVE'
      AND avail_balance > 2500;

# 3.3 https://cl.ly/35feddc71877
SELECT DISTINCT open_emp_id
FROM account;

# 3.4 https://cl.ly/119c8e327316
DESC product;

SELECT p.product_cd, a.cust_id, a.avail_balance
FROM product p INNER JOIN account a ON p.product_cd = a.product_cd
WHERE p.product_type_cd = 'ACCOUNT';










