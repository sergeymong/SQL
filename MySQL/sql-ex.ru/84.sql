# Для каждой компании подсчитать количество
# перевезенных пассажиров (если они были в этом месяце) по декадам апреля 2003.
# При этом учитывать только дату вылета.
# Вывод: название компании, количество пассажиров за каждую декаду

USE aero;

WITH res AS (SELECT ID_comp,
       ID_psg,
       date,
       CASE
         WHEN date <= DATE_ADD('2003-04-01', INTERVAL 9 day) THEN '1-10'
         WHEN date <= DATE_ADD('2003-04-01', INTERVAL 19 day) THEN '11-20'
         ELSE '21-30' END decade
FROM Trip t INNER JOIN Pass_in_trip Pit on t.trip_no = Pit.trip_no
WHERE Pit.date BETWEEN '2003-04-01' AND LAST_DAY('2003-04-01'))

SELECT (SELECT DISTINCT name FROM Company c WHERE res.ID_comp = c.ID_comp) company,
       SUM(
         IF(date
              <= DATE_ADD('2003-04-01', INTERVAL 9 day),
           1,
           0)) '1-10',
       SUM(
         IF(date
           BETWEEN DATE_ADD('2003-04-01', INTERVAL 9 day)
           AND DATE_ADD('2003-04-01', INTERVAL 19 day),
           1,
           0)) '11-20',
       SUM(
         IF(date
           BETWEEN DATE_ADD('2003-04-01', INTERVAL 19 day)
           AND LAST_DAY('2003-04-01'),
           1,
           0)) '21-30'
FROM res
GROUP BY ID_comp;
