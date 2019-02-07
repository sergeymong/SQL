# chapter 6

# unions should be with the same columns
# this is compound query
SELECT 1 num, 'abc' str
UNION
SELECT 9 num, 'xyz' str;

# union all include duplicates, but union is not
SELECT cust_id, lname name
FROM individual
UNION ALL
SELECT cust_id, name
FROM business
UNION ALL
SELECT cust_id, name
FROM business;

SELECT cust_id, lname name
FROM individual
UNION ALL
SELECT cust_id, name
FROM business
UNION
SELECT cust_id, name
FROM business;

# one more time: union all with duplicates, union is not
SELECT emp_id
FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
UNION ALL
SELECT DISTINCT open_emp_id
FROM account
WHERE open_branch_id = 2;

SELECT emp_id
FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
UNION
SELECT DISTINCT open_emp_id
FROM account
WHERE open_branch_id = 2;

# in the unions order by using only in the end
SELECT emp_id, assigned_branch_id
FROM employee
WHERE title = 'Teller'
UNION
SELECT open_emp_id, open_branch_id
FROM account
WHERE product_cd = 'SAV'
ORDER BY emp_id;

# order of unions are important
SELECT cust_id
FROM account
WHERE product_cd IN ('SAV', 'MM')
UNION ALL
SELECT a.cust_id
FROM account a INNER JOIN branch b
  ON a.open_branch_id = b.branch_id
WHERE b.name = 'Woburn Branch'
UNION
SELECT cust_id
FROM account
WHERE avail_balance BETWEEN 500 AND 2500;

# this is not the same!
SELECT cust_id
FROM account
WHERE product_cd IN ('SAV', 'MM')
UNION
SELECT a.cust_id
FROM account a INNER JOIN branch b
  ON a.open_branch_id = b.branch_id
WHERE b.name = 'Woburn Branch'
UNION ALL
SELECT cust_id
FROM account
WHERE avail_balance BETWEEN 500 AND 2500;

# order is top down. you can set order with parentheses.
# parentheses for unions are not working in mysql:)

# Homework
# 6.1 https://cl.ly/8ff712c643b1
# answers:
# 1 -- L, M, N, O, P, Q, R, S, T
# 2 -- L, M, N, O, P, P, Q, R, S, T
# 3 -- P
# 4 -- L, M, N, O

# 6.2 https://cl.ly/99a56b459f21
SELECT fname, lname
FROM individual
UNION
SELECT fname, lname
FROM employee;

# 6.3 https://cl.ly/a46bbf94f69d
SELECT fname, lname
FROM individual
UNION
SELECT fname, lname
FROM employee
ORDER BY lname;






