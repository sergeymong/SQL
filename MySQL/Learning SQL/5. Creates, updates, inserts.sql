# chapter 7
CREATE TABLE string_tbl(
  char_fld CHAR(30),
  vchar_fld VARCHAR(30),
  text_fld TEXT
);

INSERT INTO string_tbl(char_fld, vchar_fld, text_fld)
VALUES ('This is char data',
        'This is varchar data',
        'This is text data');

# if value in column more than restriction, it will be cut
# varchar not using memory, if this not using, so you can set big limits
ALTER TABLE string_tbl
MODIFY COLUMN vchar_fld VARCHAR(10000);

SELECT *
FROM string_tbl;

UPDATE string_tbl
SET vchar_fld = 'This is extremly long varchar data.';

# UPDATE string_tbl
# SET vchar_fld = 'This string doesn't work.';

# if you want apostrophe work, you should use one more apostrophe before them
UPDATE string_tbl
SET vchar_fld = 'This string doesn''t work.';

# or you can use \
UPDATE string_tbl
SET vchar_fld = 'This string doesn\'t work.';

# if you want show screening syьbols, use QUOTE
SELECT QUOTE(vchar_fld)
FROM string_tbl
UNION ALL
SELECT vchar_fld
FROM string_tbl;

SELECT CONCAT('danke sch', CHAR(148), 'n');

DELETE FROM string_tbl;

INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This string is 28 characters.',
        'This string is 28 characters.',
        'This string is 28 characters.')

SELECT *
FROM string_tbl;

SELECT LENGTH(char_fld) char_length,
       LENGTH(vchar_fld) varchar_length,
       LENGTH(text_fld) text_length
FROM string_tbl;

UPDATE string_tbl
SET char_fld = 'This string is 28 characters',
    vchar_fld = 'This string is 28 characters',
    text_fld = 'This string is 28 characters';

SELECT LENGTH(char_fld) char_length,
       LENGTH(vchar_fld) varchar_length,
       LENGTH(text_fld) text_length
FROM string_tbl;

SELECT POSITION('characters' IN vchar_fld)
FROM string_tbl;

SELECT name, name LIKE '%ns' ends_in_ns
FROM department;

SELECT cust_id, cust_type_cd, fed_id,
       fed_id REGEXP '.{3}-.{2}-.{4}' is_ss_no_format
FROM customer;

# cocncat is very useful, if you want concatenate string:)
UPDATE string_tbl
SET text_fld = CONCAT(text_fld, ', but not it is longer');

SELECT text_fld
FROM string_tbl;

SELECT CONCAT(fname, ' ', lname, ' has been a ',
  title, ' since ', start_date) emp_narrative
FROM employee
WHERE title = 'Teller' OR title = 'Head Teller';

SELECT INSERT('goodbye world', 9, 0, 'cruel ') string;
SELECT INSERT('goodbye world', 1, 7, 'hello ') string;

# select 5 symbols from 9 position
SELECT SUBSTRING('goodbye cruel world', 9, 5);

SELECT CEIL(72.445), FLOOR(72.445);

# important!
SELECT CEIL(72.00000000001), FLOOR(72.9999999999);

SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.500001);

SELECT ROUND(72.0445, 2);

# if you have restriction on
SELECT ROUND(17, -1);

# truncate just cut your number without rounding
SELECT TRUNCATE(17.09990, 2);

# Sign reutrn -1 if number < 0, 0 if number == 0, 1 if number > 0
SELECT account_id, SIGN(avail_balance), ABS(avail_balance)
FROM account;

# datetime and timezones
SELECT @@global.time_zone, @@session.time_zone;
# computer time (or server time)

SELECT CAST('2005-03-27 15:30:00' AS DATETIME);














