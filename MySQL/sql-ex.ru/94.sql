# Для семи последовательных дней, начиная от минимальной даты,
# когда из Ростова было совершено максимальное число рейсов, определить число рейсов из Ростова.
# Вывод: дата, количество рейсов


USE aero;

WITH flyes AS
       (SELECT DISTINCT T.trip_no, date
        FROM Pass_in_trip pit LEFT JOIN Trip T on pit.trip_no = T.trip_no
        WHERE town_from = 'Rostov'),
flyes_count
  AS (SELECT date, COUNT(*) flyes
      FROM flyes
      GROUP BY date),
start_count
  AS (SELECT MIN(date) date
      FROM flyes_count
      WHERE flyes = (SELECT MAX(flyes) FROM flyes_count)),
calendar
  AS (SELECT date FROM start_count
      UNION ALL
      SELECT DATE_ADD(date, INTERVAL 1 day) FROM start_count
      UNION ALL
      SELECT DATE_ADD(date, INTERVAL 2 day) FROM start_count
      UNION ALL
      SELECT DATE_ADD(date, INTERVAL 3 day) FROM start_count
      UNION ALL
      SELECT DATE_ADD(date, INTERVAL 4 day) FROM start_count
      UNION ALL
      SELECT DATE_ADD(date, INTERVAL 5 day) FROM start_count
      UNION ALL
      SELECT DATE_ADD(date, INTERVAL 6 day) FROM start_count)

SELECT date, (SELECT COUNT(*) FROM flyes f WHERE f.date = c.date) flyes
FROM calendar c;

