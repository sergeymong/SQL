# Определить время,
# проведенное в полетах, для пассажиров,
# летавших всегда на разных местах. Вывод: имя пассажира, время в минутах.

USE aero;

WITH
nec_pass
  AS (SELECT ID_psg
      FROM Pass_in_trip
      GROUP BY ID_psg
      HAVING COUNT(DISTINCT place) = COUNT(place)),
nec_trips
  AS (SELECT trip_no, np.ID_psg
      FROM Pass_in_trip pit
      INNER JOIN nec_pass np ON pit.ID_psg = np.ID_psg)

SELECT
       (SELECT name
        FROM Passenger p
         WHERE nt.ID_psg = p.ID_psg) name,
       SUM(TIMESTAMPDIFF(minute, time_out, DATE_ADD(time_in, INTERVAL IF(time_in < time_out, 1, 0) DAY))) time_total
FROM Trip t INNER JOIN nec_trips nt ON t.trip_no = nt.trip_no
GROUP BY nt.ID_psg;