# Для каждой компании, перевозившей пассажиров,
# подсчитать время, которое провели в полете самолеты с пассажирами.
# Вывод: название компании, время в минутах.

USE aero;


SELECT name, SUM(time_in_the_sky) tot_time
FROM(
SELECT DISTINCT (SELECT name
        FROM Company c
        WHERE t.ID_comp = c.ID_comp) name,
       T.ID_comp,
       pit.trip_no,
       pit.date,
        TIMESTAMPDIFF(minute, time_out,
          DATE_ADD(time_in, INTERVAL IF(time_in < time_out, 1, 0) DAY)) time_in_the_sky
FROM Pass_in_trip pit LEFT JOIN Trip T on pit.trip_no = T.trip_no) res
GROUP BY name;