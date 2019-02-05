# chapter 9

USE bank;

SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE account_id = (SELECT MAX(account_id) FROM account);

# types of subqueries

# noncorrelated subqueries
#  scalar subquery

# all accounts, opened not head teller in Woburn
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE open_emp_id <> (SELECT e.emp_id
  FROM employee e INNER JOIN branch b
    on e.assigned_branch_id = b.branch_id
  WHERE e.title = 'Head Teller' AND b.city = 'Woburn');

# all employees, having subordinates
SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id IN (SELECT superior_emp_id
  FROM employee);

# or employees, no having subordinates
SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id NOT IN (SELECT superior_emp_id
  FROM employee
  WHERE superior_emp_id IS NOT NULL);

# the same as upper
SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id <> ALL(SELECT superior_emp_id
  FROM employee
  WHERE superior_emp_id IS NOT NULL);

# all accounts, which have less avail_balance, than Frank and Tucker
SELECT account_id, cust_id, product_cd, avail_balance
FROM account
WHERE avail_balance < ALL(SELECT a.avail_balance
  FROM account a INNER JOIN individual i
    ON a.cust_id = i.cust_id
  WHERE i.fname = 'Frank' AND i.lname = 'Tucker');

SELECT account_id, product_cd, cust_id
FROM account
WHERE (open_branch_id, open_emp_id) IN
      (SELECT b.branch_id, e.emp_id
        FROM branch b INNER JOIN employee e
          ON b.branch_id = e.assigned_branch_id
        WHERE b.name = 'Woburn Branch'
          AND e.title IN ('Teller', 'Head Teller'));

# correlated sub-queries
# in correlated subquery we have link from subquery to main query
SELECT c.cust_id, c.cust_type_cd, c.city
FROM customer c
WHERE 2 = (SELECT COUNT(*)
  FROM account a
  WHERE a.cust_id = c.cust_id);

# subquery running for each row in correlated subquery
SELECT c.cust_id, c.cust_type_cd, c.city
FROM customer c
WHERE (SELECT SUM(a.avail_balance)
  FROM account a
  WHERE a.cust_id = c.cust_id)
  BETWEEN 5000 AND 10000;


# exist showing correlation between tables. 1, because not matter, that subquery return
SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account a
WHERE EXISTS(SELECT 1
  FROM transaction t
  WHERE t.account_id = a.account_id
    AND t.txn_date = '2005-01-22');

# all clients, not include in business
SELECT a.account_id, a.product_cd, a.cust_id
FROM account a
WHERE NOT EXISTS (SELECT 1
  FROM business b
  WHERE b.cust_id = a.cust_id);

UPDATE account a
SET a.last_activity_date =
      (SELECT MAX(t.txn_date)
        FROM transaction t
        WHERE t.account_id = a.account_id)
WHERE EXISTS(SELECT 1
  FROM transaction t
  WHERE t.account_id = a.account_id);

# in delete mysql not approve pseudonym
DELETE FROM department
WHERE NOT EXISTS(SELECT 1
  FROM employee
  WHERE employee.dept_id = department.dept_id);

SELECT d.dept_id, d.name, e_cnt.how_many num_employees
FROM department d INNER JOIN
  (SELECT dept_id, COUNT(*) how_many
  FROM employee
  GROUP BY dept_id) e_cnt
  ON d.dept_id = e_cnt.dept_id;

# creating tables
SELECT `groups`.name, COUNT(*) num_customers
FROM (SELECT SUM(a.avail_balance) cust_balance
  FROM account a INNER JOIN product p
    on a.product_cd = p.product_cd
  WHERE p.product_type_cd = 'ACCOUNT'
  GROUP BY a.cust_id) cust_rollup INNER JOIN
     (SELECT 'Small Fry' name, 0 low_limit, 4999.99 high_limit
     UNION ALL
     SELECT 'Average Joes' name, 5000 low_limit, 9999.99 high_limit
     UNION ALL
     SELECT 'Heavy Hitters' name, 10000 low_limit, 9999999.99 high_limit) `groups` # created table
ON cust_rollup.cust_balance
  BETWEEN`groups`.low_limit AND `groups`.high_limit # join by condition
GROUP BY `groups`.name;

# subqueries by task
SELECT p.name product, b.name branch,
       CONCAT(e.fname, ' ', e.lname) name,
       SUM(a.avail_balance) tot_deposits
FROM account a INNER JOIN employee e
  on a.open_emp_id = e.emp_id
  INNER JOIN branch b
    on a.open_branch_id = b.branch_id
  INNER JOIN product p
    on a.product_cd = p.product_cd
WHERE p.product_type_cd = 'ACCOUNT'
GROUP BY p.name, b.name, e.fname, e.lname
ORDER BY tot_deposits DESC;

# we can rewrite it with subqueries, because this query not effective
# this is our core
SELECT product_cd, open_branch_id branch_id, open_emp_id emp_id,
       SUM(avail_balance) tot_deposits
FROM account
GROUP BY product_cd, open_branch_id, open_emp_id;

SELECT p.name product, b.name branch,
       CONCAT(e.fname, ' ', e.lname) name,
       account_groups.tot_deposits
FROM
  (SELECT product_cd, open_branch_id branch_id, open_emp_id emp_id,
       SUM(avail_balance) tot_deposits
  FROM account
  GROUP BY product_cd, open_branch_id, open_emp_id) account_groups
    INNER JOIN employee e ON e.emp_id = account_groups.emp_id
    INNER JOIN branch b on b.branch_id = account_groups.branch_id
    INNER JOIN product p ON p.product_cd = account_groups.product_cd
WHERE p.product_type_cd = 'ACCOUNT';

# we can use subqueries for filtering in HAVING
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
HAVING COUNT(*) = (SELECT MAX(emp_cnt.how_many)
  FROM (SELECT COUNT(*) how_many
    FROM account
    GROUP BY open_emp_id) emp_cnt);

# we can use correlated sub-queries instead joins
SELECT
  (SELECT p.name FROM product p
    WHERE p.product_cd = a.product_cd
      AND p.product_type_cd = 'ACCOUNT') product,
  (SELECT b.name FROM branch b
    WHERE b.branch_id = a.open_branch_id) branch,
  (SELECT CONCAT(e.fname, ' ', e.lname) FROM employee e
    WHERE e.emp_id = a.open_emp_id) name,
  SUM(a.avail_balance) tot_deposits
FROM account a
GROUP BY a.product_cd, a.open_branch_id, a.open_emp_id;

# if we want delete null values, we should create one more where
SELECT all_prods.product, all_prods.branch,
       all_prods.name, all_prods.tot_deposit
FROM
     (SELECT
             (SELECT p.name FROM product p
             WHERE p.product_cd = a.product_cd
               AND p.product_type_cd = 'ACCOUNT') product,
             (SELECT b.name FROM branch b
             WHERE b.branch_id = a.open_branch_id) branch,
             (SELECT CONCAT(e.fname, ' ', e.lname) FROM employee e
             WHERE e.emp_id = a.open_emp_id) name,
             SUM(a.avail_balance) tot_deposit
     FROM account a
     GROUP BY a.product_cd, a.open_branch_id, a.open_emp_id) all_prods
WHERE all_prods.product IS NOT NULL;

# we can use subqueries in ORDER BY too
SELECT emp.emp_id, CONCAT(emp.fname, ' ', emp.lname) emp_name,
       (SELECT CONCAT(boss.fname, ' ', boss.lname)
       FROM employee boss
       WHERE boss.emp_id = emp.superior_emp_id) boss_name
FROM employee emp
WHERE emp.superior_emp_id IS NOT NULL
ORDER BY (SELECT boss.lname FROM employee boss
  WHERE boss.emp_id = emp.superior_emp_id), emp.lname;

# TODO Homework
# 9.1 https://cl.ly/2837aaed9a7a
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE product_cd IN
      (SELECT product_cd
      FROM product
        WHERE product_type_cd = 'LOAN');

# 9.2 https://cl.ly/e8e1205b7c37
SELECT a.account_id,
       a.product_cd,
       cust_id, avail_balance
FROM account a
WHERE a.product_cd =
      (SELECT p.product_cd
       FROM product p
       WHERE p.product_cd = a.product_cd
         AND p.product_type_cd = 'LOAN');
# correct answer
SELECT a.account_id,
       a.product_cd,
       cust_id, avail_balance
FROM account a
WHERE EXISTS
      (SELECT 1
       FROM product p
       WHERE p.product_cd = a.product_cd
         AND p.product_type_cd = 'LOAN');


# 9.3 https://cl.ly/35f99fac7787
SELECT emp_id, CONCAT(fname, ' ', lname) name, levels.name
FROM employee e
  INNER JOIN
  (SELECT 'trainee' name,
          '2004-01-01' start_dt,
          '2005-12-31' end_dt
   UNION ALL
    SELECT 'worker' name,
          '2002-01-01' start_dt,
          '2003-12-31' end_dt
   UNION ALL
    SELECT 'mentor' name,
          '2000-01-01' start_dt,
          '2001-12-31' end_dt
  ) levels ON e.start_date
    BETWEEN levels.start_dt
    AND levels.end_dt;

# 9.4 https://cl.ly/4ed8f74c4a58
SELECT emp_id, fname, lname,
       (SELECT d.name
       FROM department d
         WHERE d.dept_id = e.dept_id) department,
       (SELECT b.name
         FROM branch b
         WHERE b.branch_id = e.assigned_branch_id)
FROM employee e;

