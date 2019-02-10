# Определить пассажиров, которые больше других времени провели в полетах.
# Вывод: имя пассажира, общее время в минутах, проведенное в полетах


USE aero;

WITH
nec_trips
  AS (SELECT trip_no, np.ID_psg
      FROM Pass_in_trip pit
      INNER JOIN Passenger np ON pit.ID_psg = np.ID_psg),
n_tt AS
  (SELECT
       (SELECT name
        FROM Passenger p
         WHERE nt.ID_psg = p.ID_psg) name,
       SUM(TIMESTAMPDIFF(minute, time_out, DATE_ADD(time_in, INTERVAL IF(time_in < time_out, 1, 0) DAY))) time_total
FROM Trip t INNER JOIN nec_trips nt ON t.trip_no = nt.trip_no
GROUP BY nt.ID_psg)

SELECT *
FROM n_tt
WHERE time_total = (SELECT MAX(time_total) FROM n_tt);