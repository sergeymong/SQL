# chapter 13

USE bank;

SELECT dept_id, name
FROM department
WHERE name LIKE 'A%';

# indexes make searching faster
ALTER TABLE department
ADD INDEX dept_name_idx (name);

SHOW INDEX FROM department;

ALTER TABLE department
DROP INDEX dept_name_idx;

ALTER TABLE department
ADD UNIQUE dept_name_idx (name);

INSERT INTO department (dept_id, name)
VALUES (999, 'Operations');

# if we want set index for multiple columns, we can do it
ALTER TABLE employee
ADD INDEX emp_names_idx (lname, fname);
# but order very important for indexes in multiindex, because it matter for speed

SELECT cust_id, SUM(avail_balance) tot_bal
FROM account
WHERE cust_id IN (1, 5, 9, 11)
GROUP BY cust_id;

EXPLAIN SELECT cust_id, SUM(avail_balance) tot_bal
FROM account
WHERE cust_id IN (1, 5, 9, 11)
GROUP BY cust_id;

ALTER TABLE account
ADD INDEX acc_bal_idx (cust_id, avail_balance);

# after add of index, rows was less up to 3 times
EXPLAIN SELECT cust_id, SUM(avail_balance) tot_bal
FROM account
WHERE cust_id IN (1, 5, 9, 11)
GROUP BY cust_id;

# constraints

# if we have foreign-key constraint, we cannot change key-values
# in child/parent table, if we don't change key-values int the parent/child table
UPDATE product
SET product_type_cd = 'XYZ'
WHERE product_type_cd = 'LOAN';

# we can set cascade constraint. in this case values in parent/child tables
# will be update automatically

# first step, we should delete old key
ALTER TABLE product
DROP FOREIGN KEY fk_product_type_cd;

# second step, we should add new key with cascade update
ALTER TABLE product
ADD CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
  REFERENCES product_type (product_type_cd)
  ON UPDATE CASCADE;

UPDATE product_type
SET product_type_cd = 'XYZ'
WHERE product_type_cd = 'LOAN';

SELECT product_type_cd, name
FROM product_type;

SELECT product_type_cd, name
FROM product;

# so, values was changed in the both tables
# also we can set CASCADE DELETE








