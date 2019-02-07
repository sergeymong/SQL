# Chapter 4

SELECT pt.name product_type, p.name product
FROM product p
  INNER JOIN product_type pt
  ON p.product_type_cd = pt.product_type_cd
WHERE pt.name = 'Customer Accounts';

SELECT pt.name product_type, p.name product
FROM product p
  INNER JOIN product_type pt
  ON p.product_type_cd = pt.product_type_cd
WHERE pt.name != 'Customer Accounts';

DELETE FROM account
WHERE status = 'CLOSED'
  AND YEAR(close_date) = 1999;

SELECT emp_id, fname, lname, start_date
FROM employee
WHERE start_date < '2003-01-01';

SELECT emp_id, fname, lname, start_date
FROM employee
WHERE start_date
  BETWEEN '2001-01-01' AND '2003-01-01'; # lower bound the first. Also, the lower and higher bounds are include

SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE avail_balance
  BETWEEN 3000 AND 5000;

# You can sort char values, if every char is digit
SELECT cust_id, fed_id
FROM customer
WHERE cust_type_cd = 'I'
  AND fed_id
    BETWEEN '500-00-0000' AND '999-99-9999';

SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE product_cd IN ('CHK', 'SAV', 'CD', 'MM');

# the same with subquery
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE product_cd IN (SELECT product_cd FROM product
  WHERE product_type_cd = 'ACCOUNT');

SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE product_cd NOT IN ('CHK', 'SAV', 'CD', 'MM');

# conditions
SELECT emp_id, fname, lname
FROM employee
WHERE LEFT(lname, 1) = 'T'; # all employees, which name begins with t

# masks https://cl.ly/b39df74ca899
SELECT lname
FROM employee
WHERE lname LIKE '_a%e%';

SELECT cust_id, fed_id
FROM customer
WHERE fed_id LIKE '___-__-____';

# more difficult, than first condition
SELECT emp_id, fname, lname
FROM employee
WHERE lname LIKE 'F%' OR lname LIKE 'G%';

# regexp also supported!
SELECT emp_id, fname, lname
FROM employee
WHERE lname REGEXP '^[FG]';

# check for null
SELECT emp_id, fname, lname, superior_emp_id
FROM employee
WHERE superior_emp_id IS NULL;

SELECT emp_id, fname, lname, superior_emp_id
FROM employee
WHERE superior_emp_id IS NOT NULL;

# when yoy want to check something, make shure,
# that some values in the checking column not null
SELECT emp_id, fname, lname, superior_emp_id
FROM employee
WHERE superior_emp_id != 6; # we forgot Michael!

SELECT emp_id, fname, lname, superior_emp_id
FROM employee
WHERE superior_emp_id != 6 OR superior_emp_id IS NULL;

# so, when you start work with new base,
# check if it contains null

# Homework
# 4.1 https://cl.ly/a1078e354d7b
# answer -- 1, 2, 3, 5, 6, 7

# 4.2 https://cl.ly/3642968f4bfc
# answer --  4, 9

# 4.3 https://cl.ly/25167547d889
SELECT *
FROM account
WHERE YEAR(open_date) = '2002';

# 4.4 https://cl.ly/122a22118f03

DESC individual;
SELECT *
FROM individual
WHERE lname REGEXP '^.a.*e.*';













