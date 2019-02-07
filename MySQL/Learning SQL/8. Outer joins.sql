# chapter 10

USE bank;

SELECT account_id, cust_id
FROM account;

SELECT a.account_id, c.cust_id
FROM account a INNER JOIN customer c
  on a.cust_id = c.cust_id;

SELECT a.account_id, b.cust_id, b.name
FROM account a INNER JOIN business b ON a.cust_id = b.cust_id;

SELECT a.account_id, a.cust_id, b.name
FROM account a LEFT JOIN business b
  ON a.cust_id = b.cust_id;

# left join means, that left table responsible for number of rows
SELECT a.account_id, a.cust_id, CONCAT(i.fname, ' ', i.lname) name
FROM account a LEFT JOIN individual i
  ON a.cust_id = i.cust_id;

# so, right join means, that right table responsible for number of rows
SELECT a.account_id, a.cust_id, CONCAT(i.fname, ' ', i.lname) name
FROM account a RIGHT JOIN individual i
  ON a.cust_id = i.cust_id;

# full join
SELECT a.account_id, a.product_cd,
       CONCAT(i.fname, ' ', i.lname) person_name,
       b.name business_name
FROM account a LEFT JOIN individual i
  ON a.cust_id = i.cust_id
  LEFT JOIN business b
  ON a.cust_id = b.cust_id;

# the same with subqueries
SELECT account_ind.account_id, account_ind.product_cd,
       account_ind.person_name,
       b.name business_name
FROM
  (SELECT a.account_id, a.product_cd, a.cust_id,
          CONCAT(i.fname, ' ', i.lname) person_name
    FROM account a LEFT JOIN individual i
      ON a.cust_id = i.cust_id) account_ind
  LEFT JOIN business b
  ON account_ind.cust_id = b.cust_id;

# recursive joins
# all employees and their bosses
SELECT e.fname, e.lname,
       e_mgr.fname mgr_name, e_mgr.lname mgr_lname
FROM employee e LEFT JOIN employee e_mgr
  ON e.superior_emp_id = e_mgr.emp_id;

# cross-joins
SELECT pt.name, p.product_cd, p.name
FROM product p CROSS JOIN product_type pt;

# with cross-join we can create sequence
SELECT DATE_ADD('2004-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
FROM
     (SELECT 0 num UNION ALL
       SELECT 1 num UNION ALL
       SELECT 2 num UNION ALL
       SELECT 3 num UNION ALL
       SELECT 4 num UNION ALL
       SELECT 5 num UNION ALL
       SELECT 6 num UNION ALL
       SELECT 7 num UNION ALL
       SELECT 8 num UNION ALL
       SELECT 9 num) ones
      CROSS JOIN
       (SELECT 0 num UNION ALL
       SELECT 10 num UNION ALL
       SELECT 20 num UNION ALL
       SELECT 30 num UNION ALL
       SELECT 40 num UNION ALL
       SELECT 50 num UNION ALL
       SELECT 60 num UNION ALL
       SELECT 70 num UNION ALL
       SELECT 80 num UNION ALL
       SELECT 90 num) tens
      CROSS JOIN
       (SELECT 0 num UNION ALL
       SELECT 100 num UNION ALL
       SELECT 200 num UNION ALL
       SELECT 300 num UNION ALL
       SELECT 400 num UNION ALL
       SELECT 500 num UNION ALL
       SELECT 600 num UNION ALL
       SELECT 700 num UNION ALL
       SELECT 800 num UNION ALL
       SELECT 900 num) hundreds
    WHERE DATE_ADD('2004-01-01',
        INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2005-01-01';

# how many accounts have been opened each day
SELECT days.dt, COUNT(a.account_id)
FROM account a RIGHT JOIN
  (SELECT DATE_ADD('2004-01-01',
    INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
  FROM
  (SELECT 0 num UNION ALL
       SELECT 1 num UNION ALL
       SELECT 2 num UNION ALL
       SELECT 3 num UNION ALL
       SELECT 4 num UNION ALL
       SELECT 5 num UNION ALL
       SELECT 6 num UNION ALL
       SELECT 7 num UNION ALL
       SELECT 8 num UNION ALL
       SELECT 9 num) ones
      CROSS JOIN
       (SELECT 0 num UNION ALL
       SELECT 10 num UNION ALL
       SELECT 20 num UNION ALL
       SELECT 30 num UNION ALL
       SELECT 40 num UNION ALL
       SELECT 50 num UNION ALL
       SELECT 60 num UNION ALL
       SELECT 70 num UNION ALL
       SELECT 80 num UNION ALL
       SELECT 90 num) tens
      CROSS JOIN
       (SELECT 0 num UNION ALL
       SELECT 100 num UNION ALL
       SELECT 200 num UNION ALL
       SELECT 300 num) hundreds
    WHERE DATE_ADD('2004-01-01',
        INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2005-01-01') days
  ON days.dt = a.open_date
GROUP BY days.dt;

# natural join. automatically search ON. NOT RECOMMEND
SELECT a.account_id, a.cust_id, c.cust_type_cd, c.fed_id
FROM account a NATURAL JOIN customer c;

# Homework
# 10.1 https://cl.ly/df8654021470
SELECT a.account_id, p.product_cd, a.avail_balance, a.cust_id
FROM account a RIGHT JOIN product p
  on a.product_cd = p.product_cd;


# 10.2 https://cl.ly/e1f910a6453a
SELECT p.product_cd, a.account_id,  a.avail_balance, a.cust_id
FROM product p LEFT JOIN account a
  on a.product_cd = p.product_cd;

# 10.3 https://cl.ly/3dbee8850a4b
SELECT a.account_id, a.product_cd, i.fname, i.lname, b.name
FROM account a
  LEFT JOIN individual i ON i.cust_id = a.cust_id
  LEFT JOIN business b ON b.cust_id = a.cust_id;

# or
SELECT a.account_id, a.product_cd,
       CASE
         WHEN EXISTS
           (SELECT 1
           FROM customer c
           WHERE c.cust_id = a.cust_id
             AND c.cust_type_cd = 'B')
         THEN
           (SELECT name
           FROM business b
           WHERE a.cust_id = b.cust_id)
         ELSE
           (SELECT CONCAT(i.fname, ' ', i.lname)
           FROM individual i
           WHERE a.cust_id = i.cust_id) END name
FROM account a;


# 10.4 https://cl.ly/702ca838a2ad
SELECT nums
FROM(
SELECT ones.num + tens.num + hund.num nums
FROM (SELECT 0 num UNION ALL
      SELECT 1 num UNION ALL
      SELECT 2 num UNION ALL
      SELECT 3 num UNION ALL
      SELECT 4 num UNION ALL
      SELECT 5 num UNION ALL
      SELECT 6 num UNION ALL
      SELECT 7 num UNION ALL
      SELECT 8 num UNION ALL
      SELECT 9 num) ones CROSS JOIN
      (SELECT 0 num UNION ALL
      SELECT 10 num UNION ALL
      SELECT 20 num UNION ALL
      SELECT 30 num UNION ALL
      SELECT 40 num UNION ALL
      SELECT 50 num UNION ALL
      SELECT 60 num UNION ALL
      SELECT 70 num UNION ALL
      SELECT 80 num UNION ALL
      SELECT 90 num) tens CROSS JOIN
     (SELECT 0 num UNION ALL
       SELECT 100 num) hund) res
WHERE nums BETWEEN 1 AND 100
ORDER BY nums;
