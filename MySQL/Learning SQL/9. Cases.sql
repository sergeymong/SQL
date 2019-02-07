# chapter 11

USE bank;

SELECT c.cust_id, c.fed_id, c.cust_type_cd,
       CONCAT(i.fname, ' ', i.lname) ind_name,
       b.name bus_name
FROM customer c LEFT JOIN individual i
  on c.cust_id = i.cust_id
  LEFT JOIN business b
    on c.cust_id = b.cust_id;

# with case we can drop null values in column
SELECT c.cust_id, c.fed_id,
       CASE
         WHEN c.cust_type_cd = 'I'
           THEN CONCAT(i.fname, ' ', i.lname)
         WHEN c.cust_type_cd = 'B'
           THEN b.name
         ELSE 'Unknown'
       END name
FROM customer c LEFT JOIN individual i
  on c.cust_id = i.cust_id
  LEFT JOIN business b
    on c.cust_id = b.cust_id;

# all values, returned from then should be the same type.
# case can return subqeries
SELECT c.cust_id, c.fed_id,
       CASE
          WHEN c.cust_type_cd = 'I' THEN
            (SELECT CONCAT(i.fname, ' ', i.lname)
              FROM individual i
              WHERE i.cust_id = c.cust_id)
          WHEN c.cust_type_cd = 'B' THEN
            (SELECT b.name
              FROM business b
              WHERE b.cust_id = c.cust_id)
            ELSE 'Unknown'
          END name
FROM customer c;

# simple case
CASE customer.cust_type_cd # what we compare
  WHEN 'I' THEN
  (SELECT CONCAT(i.fname, ' ', i.lname)
              FROM individual i
              WHERE i.cust_id = c.cust_id)
  WHEN 'B' THEN
  (SELECT b.name
              FROM business b
              WHERE b.cust_id = c.cust_id)
  ELSE 'Unknown Customer Type'
END

# it's the same as if cust_type = 'I': subquery,
# elif cust_type = 'B': subquery, else 'Message'
SELECT YEAR(open_date) year, COUNT(*) how_many
FROM account
WHERE open_date > '1991-12-31'
GROUP BY YEAR(open_date);


# if you want transpose results, case with help you with this
SELECT
  SUM(CASE
        WHEN EXTRACT(YEAR FROM open_date) = 2000 THEN 1
        ELSE 0
      END) year_2000,
  SUM(CASE
        WHEN EXTRACT(YEAR FROM open_date) = 2001 THEN 1
        ELSE 0
      END) year_2001,
  SUM(CASE
        WHEN EXTRACT(YEAR FROM open_date) = 2002 THEN 1
        ELSE 0
      END) year_2002,
  SUM(CASE
        WHEN EXTRACT(YEAR FROM open_date) = 2003 THEN 1
        ELSE 0
      END) year_2003,
  SUM(CASE
        WHEN EXTRACT(YEAR FROM open_date) = 2004 THEN 1
        ELSE 0
      END) year_2004,
  SUM(CASE
        WHEN EXTRACT(YEAR FROM open_date) = 2005 THEN 1
        ELSE 0
      END) year_2005
FROM account
WHERE open_date > '1999-12-31';

# query, where we want search all accounts, when fact not equal table result
SELECT CONCAT('ALERT! : Account #', a.account_id, ' Has Incorrect Balance!')
FROM account a
WHERE (a.avail_balance, a.pending_balance) <>
      (SELECT
          SUM(CASE
                WHEN t.funds_avail_date > CURRENT_TIMESTAMP()
                  THEN 0
                WHEN t.txn_type_cd = 'DBT'
                  THEN t.amount * -1
                ELSE t.amount
            END),
          SUM(CASE
                WHEN t.txn_type_cd = 'DBT'
                  THEN t.amount * -1
                ELSE t.amount
            END)
      FROM transaction t
      WHERE t.account_id = a.account_id);

# if we want check, which types of accounts client opened
SELECT c.cust_id, c.fed_id, c.cust_type_cd,
       CASE
          WHEN EXISTS(SELECT 1 FROM account a
            WHERE a.cust_id = c.cust_id
              AND a.product_cd = 'CHK') THEN 'Y'
          ELSE 'N'
       END has_checking,
       CASE
          WHEN EXISTS(SELECT 1 FROM account a
            WHERE a.cust_id = c.cust_id
              AND a.product_cd = 'SAV') THEN 'Y'
          ELSE 'N'
       END has_savings
FROM customer c;


SELECT c.cust_id, c.fed_id, c.cust_type_cd,
       CASE (SELECT COUNT(*) FROM account a
          WHERE a.cust_id = c.cust_id)
       WHEN 0 THEN 'None'
       WHEN 1 THEN '1'
       WHEN 2 THEN '2'
       ELSE '3+'
       END num_accounts
FROM customer c;

# if we want to choose only 3+ clients, we should write this
SELECT *
FROM (
SELECT c.cust_id, c.fed_id, c.cust_type_cd,
       CASE (SELECT COUNT(*) FROM account a
          WHERE a.cust_id = c.cust_id)
       WHEN 0 THEN 'None'
       WHEN 1 THEN '1'
       WHEN 2 THEN '2'
       ELSE '3+'
       END num_accounts
FROM customer c) res
WHERE num_accounts = '3+';

SELECT 100/0;

# we should use case with denominator, because mysql set null value,
# if denominator = 0, but this is not correct
SELECT a.cust_id, a.product_cd, a.avail_balance /
  CASE
    WHEN prod_tots.tot_balance = 0 THEN 1
    ELSE prod_tots.tot_balance
  END percent_of_total
FROM account a INNER JOIN
     (SELECT a.product_cd, SUM(a.avail_balance) tot_balance
       FROM account a
       GROUP BY a.product_cd) prod_tots
      ON a.product_cd = prod_tots.product_cd;


select *
from department;

# Homework

# 11.1 rewrite query with CASE https://cl.ly/245ea5263220
SELECT emp_id, CASE title
  WHEN 'President' THEN 'Management'
  WHEN 'Vice President' THEN 'Management'
  WHEN 'Treasurer' THEN 'Management'
  WHEN 'Loan Manager' THEN 'Management'
  WHEN 'Operations Manager' THEN 'Operations'
  WHEN 'Head Teller' THEN 'Operations'
  WHEN 'Teller' THEN 'Operations'
  ELSE 'Unknown'
END
FROM employee;

# rewritten query
SELECT emp_id,
       CASE
          WHEN title IN ('President' , 'Vice President',
                         'Treasurer', 'Loan Manager') THEN 'Management'
          WHEN title IN ('Operations Manager',
                         'Head Teller', 'Teller') THEN 'Operations'
          ELSE 'Unknown'
END title
FROM employee;

# or
SELECT emp_id,
       (SELECT CASE WHEN name IN ('Loans', 'Administration')
         THEN 'Management' ELSE name END name
         FROM department d
         WHERE d.dept_id = e.dept_id) title
FROM employee e
ORDER BY emp_id;

# 11.2 https://cl.ly/5d665f1d3b6e
SELECT
       SUM(CASE
          WHEN open_branch_id = 1 THEN 1 ELSE 0 END) branch_1,
       SUM(CASE
          WHEN open_branch_id = 2 THEN 1 ELSE 0 END) branch_2,
       SUM(CASE
          WHEN open_branch_id = 3 THEN 1 ELSE 0 END) branch_3,
       SUM(CASE
          WHEN open_branch_id = 4 THEN 1 ELSE 0 END) branch_4
FROM account;



