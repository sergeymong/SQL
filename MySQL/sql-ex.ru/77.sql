# Определить дни, когда было выполнено максимальное число рейсов из
# Ростова ('Rostov'). Вывод: число рейсов, дата.

USE aero;

EXPLAIN WITH
rostov
  AS (SELECT date, town_from,  COUNT(DISTINCT t.trip_no) flights
      FROM Trip t INNER JOIN Pass_in_trip pit on t.trip_no = Pit.trip_no
      WHERE town_from = 'Rostov'
      GROUP BY date, town_from)

SELECT flights, date
FROM rostov
WHERE flights = (SELECT MAX(flights) FROM rostov);