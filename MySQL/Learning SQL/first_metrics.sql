USE open_data;

# mutate table
UPDATE transactions
SET CustomerID = 0
WHERE CustomerID IS NULL;

UPDATE transactions
SET date = DATE(date);

ALTER TABLE transactions
ADD COLUMN tot DOUBLE AS (Quantity * UnitPrice) AFTER UnitPrice;

ALTER TABLE transactions
  DROP COLUMN tot;

ALTER TABLE transactions
  MODIFY date timestamp FIRST ;

DROP INDEX users ON transactions;

SELECT *
FROM transactions;

DESCRIBE transactions;

SHOW INDEX FROM transactions;

CREATE INDEX users ON transactions(CustomerID);
CREATE INDEX dates ON transactions(date);
CREATE INDEX invoice ON transactions(InvoiceNo);


### OLD METRICS
WITH
customers
  AS(SELECT CustomerID,
            ROUND(SUM(UnitPrice * Quantity), 0) cl_check,
            MIN(date) first_trans,
            MAX(date) last_trans,
            DATEDIFF(MAX(date), MIN(date)) days_with_us,
            COUNT(DISTINCT InvoiceNo) transactions
  FROM transactions
  GROUP BY CustomerID),
dwm_au
  AS (SELECT metric, ROUND(AVG(users), 0) val
      FROM (SELECT EXTRACT(DAY FROM date) day, COUNT(DISTINCT CustomerID) users, 'DAU' metric
            FROM transactions
            GROUP BY EXTRACT(DAY FROM date), EXTRACT(WEEK FROM date)
            UNION ALL
            SELECT EXTRACT(WEEK FROM date) day, COUNT(DISTINCT CustomerID) users, 'WAU' metric
            FROM transactions
            GROUP BY EXTRACT(WEEK FROM date)
            UNION ALL
            SELECT EXTRACT(MONTH FROM date) day, COUNT(DISTINCT CustomerID) users, 'MAU' metric
            FROM transactions
            GROUP BY EXTRACT(MONTH FROM date)) res
      GROUP BY metric),
ltv
  AS (SELECT ROUND(AVG(days_with_us) * AVG(cl_check), 0) LTV,
       ROUND(
         (SELECT AVG(transactions)
         FROM customers
         WHERE transactions > 1)
         * AVG(days_with_us)
         * (SELECT AVG(tots)
            FROM
                 (SELECT SUM(Quantity * UnitPrice) tots
                 FROM transactions
                 GROUP BY InvoiceNo) res), 0) LTV_plus
      FROM customers),
arppu
  AS (SELECT ROUND(AVG(APRU), 0) ARPPU, 'DAU' type
      FROM (SELECT SUM(UnitPrice * Quantity) / (SELECT val FROM dwm_au WHERE metric = 'DAU') APRU
            FROM transactions
            GROUP BY EXTRACT(DAY FROM date), EXTRACT(WEEK FROM date)) res)
      #UNION ALL
      #SELECT ROUND(AVG(APRU), 0) ARPPU, 'WAU' type
      #FROM (SELECT SUM(UnitPrice * Quantity) / (SELECT val FROM dwm_au WHERE metric = 'WAU') APRU
      #      FROM transactions
      #      GROUP BY EXTRACT(WEEK FROM date)) res
      #UNION ALL
      #SELECT ROUND(AVG(APRU), 0) ARPPU, 'MAU' type
      #FROM (SELECT SUM(UnitPrice * Quantity) / (SELECT val FROM dwm_au WHERE metric = 'MAU') APRU
      #      FROM transactions
      #      GROUP BY EXTRACT(MONTH FROM date)) res)

SELECT *
FROM dwm_au
UNION ALL
SELECT 'ARPPU' what, arppu val
FROM arppu
UNION ALL
SELECT 'LTV', LTV
FROM ltv;
### OLD METRICS END

### NEW METRICS
WITH clients
  AS (SELECT CustomerID,
            ROUND(SUM(tot), 1) cl_check,
            DATEDIFF(MAX(date), MIN(date)) days_with_us,
            COUNT(DISTINCT InvoiceNo) transactions
      FROM transactions
      GROUP BY CustomerID),
transactions
  AS (SELECT date,
       ROUND(SUM(tot), 1) tot_rev,
       COUNT(DISTINCT CustomerID) DAU,
       ROUND(SUM(tot) / COUNT(DISTINCT InvoiceNo), 1) avg_check,
       ROUND(SUM(tot) / COUNT(DISTINCT CustomerID), 1) avg_per_user
      FROM transactions
      GROUP BY date)

SELECT 'LTV' what,
       ROUND(AVG(transactions) * AVG(days_with_us)
         * (SELECT AVG(avg_check) FROM transactions), 1) val
FROM clients
UNION ALL
SELECT 'DAU' what, ROUND(AVG(DAU), 1) val
FROM transactions
UNION ALL
SELECT 'WAU' what, ROUND(AVG(val), 1) val
FROM (SELECT ROUND(SUM(DAU), 1) val
FROM transactions
GROUP BY EXTRACT(WEEK FROM open_data.transactions.date)) wau
UNION ALL
SELECT 'MAU' what, ROUND(AVG(val), 1) val
FROM (SELECT ROUND(SUM(DAU), 1) val
FROM transactions
GROUP BY EXTRACT(MONTH FROM open_data.transactions.date)) mau
UNION ALL
SELECT 'ARPPU' what, (SELECT ROUND(AVG(tot_rev/DAU), 1) FROM transactions) val;
### NEW METRICS END

# old metrics 5.5 sec, new metrics 2.5 sec (WITH INDICES)
# old metrics 4.8 sec, new metrics 1.7 sec (WITHOUT INDICES)


# top 10 stocks by number of purchases
SELECT StockCode, COUNT(*) bought, ROUND(COUNT(*) * AVG(UnitPrice), 0) tot_rev
FROM transactions t1
GROUP BY StockCode
ORDER BY COUNT(*) DESC
LIMIT 10;

# top 10 stocks by total revenue
SELECT StockCode, COUNT(*) bought, ROUND(COUNT(*) * AVG(UnitPrice), 0) tot_rev
FROM transactions t1
GROUP BY StockCode
ORDER BY tot_rev DESC
LIMIT 10;

# top countries by avg_revenue
SELECT Country,
       COUNT(*) transactions,
       ROUND(SUM(UnitPrice * Quantity), 0) tot_rev,
       ROUND(SUM(UnitPrice * Quantity) / COUNT(*), 0) avg_rev,
       COUNT(DISTINCT CustomerID) users
FROM transactions
GROUP BY Country
ORDER BY avg_rev DESC;

# customers, which decrease average check
WITH problem_customers
  AS (SELECT CustomerID,
       COUNT(*) transactions,
       ROUND(SUM(UnitPrice * Quantity), 0) tot_rev,
       ROUND(SUM(UnitPrice * Quantity) / COUNT(*), 0) avg_rev
    FROM transactions
    WHERE Country = 'United Kingdom'
    GROUP BY CustomerID
    HAVING COUNT(*) > 1
    ORDER BY avg_rev)

# all goods, which bought problem customers
SELECT Description, ROUND(AVG(UnitPrice), 0) avg_UnitPrice
FROM transactions
WHERE CustomerID IN
      (SELECT CustomerID
      FROM problem_customers
      WHERE avg_rev < 18)
GROUP BY Description
ORDER BY AVG(UnitPrice) DESC;

