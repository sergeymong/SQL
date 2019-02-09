# Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov.
# Вывод: дата, количество рейсов

USE aero;

WITH
tr_fr_ro AS (SELECT CAST(date AS DATE) dt, COUNT(DISTINCT Trip.trip_no) flyes
              FROM Trip
                LEFT JOIN Pass_in_trip Pit
                on Trip.trip_no = Pit.trip_no
              WHERE town_from = 'Rostov'
                AND date IS NOT NULL
                AND date BETWEEN '2003-04-01' AND '2003-04-07'
              GROUP BY CAST(date AS DATE)),
dates AS (SELECT DATE_ADD('2003-04-01', INTERVAL (ones.num) DAY) day
          FROM
          (SELECT 0 num UNION ALL
            SELECT 1 num UNION ALL
            SELECT 2 num UNION ALL
            SELECT 3 num UNION ALL
            SELECT 4 num UNION ALL
            SELECT 5 num UNION ALL
            SELECT 6 num) ones)


SELECT day, COALESCE(flyes, 0) flyes
FROM dates
 LEFT JOIN tr_fr_ro ON tr_fr_ro.dt = dates.day;


# for sql-ex (DATE_ADD not work)
WITH
tr_fr_ro AS (SELECT date dt, COUNT(DISTINCT Trip.trip_no) flyes
              FROM Trip
                LEFT JOIN Pass_in_trip Pit
                on Trip.trip_no = Pit.trip_no
              WHERE town_from = 'Rostov'
                AND date IS NOT NULL
                AND date BETWEEN '2003-04-01' AND '2003-04-07'
              GROUP BY date),
dates AS (SELECT CAST(num AS DATETIME) day
          FROM
          (SELECT '2003-04-01' num UNION ALL
            SELECT '2003-04-02' num UNION ALL
            SELECT '2003-04-03' num UNION ALL
            SELECT '2003-04-04' num UNION ALL
            SELECT '2003-04-05' num UNION ALL
            SELECT '2003-04-06' num UNION ALL
            SELECT '2003-04-07' num) ones)

SELECT day, COALESCE(flyes, 0) flyes
FROM dates
 LEFT JOIN tr_fr_ro ON tr_fr_ro.dt = dates.day;


