# chapter 5

# cross join -- multiplying all variants
SELECT e.fname, e.lname, d.name
FROM employee e
  JOIN department d;

# inner join -- because we use key. most useful. this join type by default
# all variants, which has in the both tables.
SELECT e.fname, e.lname, d.name
FROM employee e
  JOIN department d on e.dept_id = d.dept_id;

# if names of key column in the both tables are same, we can use USING
SELECT e.fname, e.lname, d.name
FROM employee e
  INNER JOIN department d USING (dept_id);

# this is old format of join
SELECT e.fname, e.lname, d.name
FROM employee e, department d
WHERE e.dept_id = d.dept_id;

# in the difficult queries this format are bad
# we don't understand difference between where and join
SELECT a.account_id, a.cust_id, a.open_date, a.product_cd
FROM account a, branch b, employee e
WHERE a.open_emp_id = e.emp_id
  AND e.start_date <= '2003-01-01'
  AND e.assigned_branch_id = b.branch_id
  AND (e.title = 'Teller' OR e.title = 'Head Teller')
  AND b.name = 'Woburn Branch';

# but in new format this problem solved
SELECT a.account_id, a.cust_id, a.open_date, a.product_cd
FROM account a
  INNER JOIN employee e
    ON a.open_emp_id = e.emp_id
  INNER JOIN branch b
    ON a.open_branch_id = b.branch_id
WHERE e.start_date <= '2003-01-01'
  AND (e.title = 'Teller' OR e.title = 'Head Teller')
  AND b.name = 'Woburn Branch';

# when we join more, than 2 tables, we use two joins and on
# important moment -- we join two tables with table a
SELECT a.account_id, c.fed_id, e.fname, e.lname
FROM account a
  INNER JOIN customer c
    on a.cust_id = c.cust_id
  INNER JOIN employee e
    on a.open_emp_id = e.emp_id
WHERE c.cust_type_cd = 'B';

# subqueries
SELECT a.account_id, a.cust_id, a.open_date, a.product_cd
FROM account a INNER JOIN
     (SELECT emp_id, assigned_branch_id
       FROM employee
       WHERE start_date <= '2003-01-01'
       AND (title = 'Teller' OR title = 'Head Teller')) e
      ON a.open_emp_id = e.emp_id
  # first part: found all accounts,
  # which opened skilled employee
      INNER JOIN
        (SELECT branch_id
          FROM branch
          WHERE name = 'Woburn Branch') b
      ON e.assigned_branch_id = b.branch_id;
  # second part create new filter: all skilled employee
  # from branch with id = 2 (Woburn Branch)
  # and the final answer we get all accounts opened
  # skilled employees from Woburn Branch

# in the query we can use table many times,
# but with the different names
SELECT a.account_id, e.emp_id,
       b_a.name open_branch, b_e.name emp_branch
FROM account a INNER JOIN branch b_a
  ON a.open_branch_id = b_a.branch_id
  INNER JOIN employee e
  ON a.open_emp_id = e.emp_id
  INNER JOIN branch b_e
  ON e.assigned_branch_id = b_e.branch_id
WHERE a.product_cd = 'CHK';
# but in this example this is not sense

# recursive joins
SELECT e.fname, e.lname,
       e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
FROM employee e INNER JOIN employee e_mgr
  ON e.superior_emp_id = e_mgr.emp_id;

# this was equi-joins, when in ON our keys are equal
# but not-equi-joins also exist
SELECT e.emp_id, e.fname, e.lname, e.start_date
FROM employee e INNER JOIN product p
  ON e.start_date >= p.date_offered
    AND e.start_date <= p.date_retired
WHERE p.name = 'no-fee checking';

# also we can use self-non-equi-join
# for example, create all pairs employees
SELECT e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
FROM employee e1
  INNER JOIN employee e2
    ON e1.emp_id != e2.emp_id
WHERE e1.title = 'Teller' AND e2.title = 'Teller';
# problem here in the doubled of pairs, we can solve this
# if create different condition

SELECT e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
FROM employee e1
  INNER JOIN employee e2
    ON e1.emp_id < e2.emp_id
WHERE e1.title = 'Teller' AND e2.title = 'Teller';

# TODO Homework
# 5.1 https://cl.ly/19c7ccac0e99
SELECT e.emp_id, e.fname, e.lname, b.name
FROM employee e INNER JOIN branch b
  on e.assigned_branch_id = b.branch_id;

# 5.2 https://cl.ly/b80ef38f6bd1
SELECT a.account_id, c.fed_id, p.name
FROM customer c
  INNER JOIN account a
    ON c.cust_id = a.cust_id
  INNER JOIN product p
    ON a.product_cd = p.product_cd
WHERE c.cust_type_cd = 'I';

# 5.3 https://cl.ly/0a962c972a5a
SELECT e1.fname, e1.lname
FROM employee e1
  INNER JOIN employee e2
    ON e1.superior_emp_id = e2.emp_id
WHERE e1.dept_id != e2.dept_id;













