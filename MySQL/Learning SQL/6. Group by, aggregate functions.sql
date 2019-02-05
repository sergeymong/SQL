# chapter 8
USE bank;

SELECT open_emp_id
FROM account
GROUP BY open_emp_id;

SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id;

# you cannot use aggregate before group by, because group not yet exist
SELECT open_emp_id, COUNT(*) how_many
FROM account
WHERE COUNT(*) > 4
GROUP BY open_emp_id;

# but you can use HAVING for this task
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
HAVING COUNT(*) > 4;

# because group_by not announced, we have only one unidentified group
SELECT MAX(avail_balance) max_balance,
       MIN(avail_balance) min_balance,
       AVG(avail_balance) avg_balance,
       SUM(avail_balance) tot_balance,
       COUNT(*) num_accounts
FROM account
WHERE product_cd = 'CHK';

# if we want see each group, we need specify group by
SELECT product_cd,
       MAX(avail_balance) max_balance,
       MIN(avail_balance) min_balance,
       AVG(avail_balance) avg_balance,
       SUM(avail_balance) tot_balance,
       COUNT(*) num_accounts
FROM account;

SELECT product_cd,
       MAX(avail_balance) max_balance,
       MIN(avail_balance) min_balance,
       AVG(avail_balance) avg_balance,
       SUM(avail_balance) tot_balance,
       COUNT(*) num_accounts
FROM account
GROUP BY product_cd;

# you can use operations in aggregate functions
SELECT MAX(pending_balance - avail_balance) max_uncleared
FROM account;

CREATE TABLE number_tbl
(val SMALLINT);

INSERT INTO number_tbl VALUES (1);
INSERT INTO number_tbl VALUES (3);
INSERT INTO number_tbl VALUES (5);

SELECT *
FROM number_tbl;

SELECT COUNT(*) num_rows,
       COUNT(val) num_vals,
       SUM(val) total,
       MAX(val) max_val,
       AVG(val) avg_val
FROM number_tbl;

INSERT INTO number_tbl VALUES (NULL);

# so, if we have null values, rows will be count!
SELECT COUNT(*) num_rows,
       COUNT(val) num_vals,
       SUM(val) total,
       MAX(val) max_val,
       AVG(val) avg_val
FROM number_tbl;

DROP TABLE number_tbl;
DROP TABLE string_tbl;

# grouping
SELECT product_cd, SUM(avail_balance) prod_balance
FROM account
GROUP BY product_cd;

SELECT product_cd, open_branch_id, SUM(avail_balance) prod_balance
FROM account
GROUP BY product_cd, open_branch_id;

# you can grouping with operations
SELECT EXTRACT(YEAR FROM start_date) year,
       COUNT(*) how_many
FROM employee
GROUP BY EXTRACT(YEAR FROM start_date);

# with rollup -- summary for each product_cd group and overall summary
SELECT product_cd, open_branch_id,
       SUM(avail_balance) tot_balance
FROM account
GROUP BY product_cd, open_branch_id WITH ROLLUP;

# where work on the raw data, but having work on grouped data
SELECT product_cd, SUM(avail_balance) prod_balance
FROM account
WHERE status = 'ACTIVE'
GROUP BY product_cd
HAVING SUM(avail_balance) >= 10000;

# also, in having we can use aggregation functions non included in SELECT
SELECT product_cd, SUM(avail_balance) prod_balance
FROM account
WHERE status = 'ACTIVE'
GROUP BY product_cd
HAVING MIN(avail_balance) >= 1000
       AND MAX(avail_balance) <= 10000;


# TODO Homework
# 8.1 https://cl.ly/f02492840792
SELECT COUNT(*)
FROM account;

# 8.2 https://cl.ly/4d6d065f88da
SELECT cust_id, COUNT(*)
FROM account
GROUP BY cust_id;

# 8.3 https://cl.ly/9299f03d3213
SELECT cust_id, COUNT(*)
FROM account
GROUP BY cust_id
HAVING COUNT(*) >= 2;

# 8.4 https://cl.ly/48f5accac951
SELECT product_cd, open_branch_id, SUM(avail_balance) tot_bal
FROM account
GROUP BY product_cd, open_branch_id
HAVING COUNT(*) > 1
ORDER BY tot_bal DESC;
# also can
#ORDER BY 3 DESC;









