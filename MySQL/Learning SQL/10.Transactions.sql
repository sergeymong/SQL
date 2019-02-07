# chapter 12

USE bank;

SET AUTOCOMMIT = 0;

SHOW TABLE STATUS LIKE 'transaction'


START TRANSACTION;

UPDATE product
SET date_retired = CURRENT_TIMESTAMP()
WHERE product_cd  = 'XYZ';

SAVEPOINT before_close_accounts; # create point, if we want to backup in this state

UPDATE account
SET status = 'CLOSED', close_date = CURRENT_TIMESTAMP(),
    last_activity_date = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';

ROLLBACK TO SAVEPOINT before_close_accounts; # rollback without savepoint undo all transaction operations

COMMIT;


