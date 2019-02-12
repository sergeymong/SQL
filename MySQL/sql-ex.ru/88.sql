# Среди тех, кто пользуется услугами только одной компании,
# определить имена разных пассажиров, летавших чаще других.
# Вывести: имя пассажира, число полетов и название компании.

USE aero;

WITH trip_and_comp
  AS (SELECT trip_no, ID_psg,
       (SELECT (SELECT name FROM Company c WHERE c.ID_comp = t.ID_comp)
         FROM Trip t
         WHERE pit.trip_no = T.trip_no) company
      FROM Pass_in_trip pit),
mono_pass
  AS (SELECT ID_psg, COUNT(*) flyes
      FROM trip_and_comp
      GROUP BY ID_psg
      HAVING COUNT(DISTINCT company) = 1)

SELECT (SELECT name FROM Passenger p WHERE p.ID_psg = mp.ID_psg) name,
       flyes,
       (SELECT DISTINCT company FROM trip_and_comp tac WHERE mp.ID_psg = tac.ID_psg) company
FROM mono_pass mp
WHERE flyes = (SELECT MAX(flyes) FROM mono_pass);
