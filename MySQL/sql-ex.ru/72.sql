# Среди тех, кто пользуется услугами только какой-нибудь одной компании,
# определить имена разных пассажиров, летавших чаще других.
# Вывести: имя пассажира и число полетов.

USE aero;

WITH tr_all_p AS
       (SELECT T.trip_no,
               ID_comp,
               (SELECT name FROM Passenger p WHERE p.ID_psg = Pit.ID_psg) pass
       FROM Pass_in_trip Pit LEFT JOIN Trip T on Pit.trip_no = T.trip_no),
passengers AS
  (SELECT pass, COUNT(trip_no) trips
   FROM tr_all_p
   WHERE pass IN
                (SELECT pass
                FROM tr_all_p
                GROUP BY pass
                HAVING COUNT(DISTINCT ID_comp) = 1)
   GROUP BY pass)

SELECT *
FROM passengers
HAVING trips = (SELECT MAX(trips) FROM passengers);



SELECT *
FROM Trip;