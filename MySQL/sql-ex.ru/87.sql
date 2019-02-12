# Считая, что пункт самого первого вылета пассажира является местом жительства,
# найти не москвичей, которые прилетали в Москву более одного раза.
# Вывод: имя пассажира, количество полетов в Москву

USE aero;

WITH
flyes AS
        (SELECT CONCAT(DATE(date), ' ', TIME(time_out)) time_date, T.trip_no, ID_psg, town_from
         FROM Pass_in_trip LEFT JOIN Trip T on Pass_in_trip.trip_no = T.trip_no
         ORDER BY ID_psg, date, time_out),
first_fly_date AS
          (SELECT MIN(time_date) first_fly, ID_psg
           FROM flyes
           GROUP BY ID_psg),
not_moscow_citizens AS
  (SELECT f.ID_psg, town_from hometown
   FROM first_fly_date ffd INNER JOIN flyes f ON f.time_date = ffd.first_fly AND ffd.ID_psg = f.ID_psg
   WHERE town_from != 'Moscow')

SELECT DISTINCT (SELECT name FROM Passenger p WHERE pit.ID_psg = p.ID_psg) name, COUNT(*) flyes_to_moscow
FROM Pass_in_trip pit LEFT JOIN Trip T2 on pit.trip_no = T2.trip_no
WHERE ID_psg IN (SELECT ID_psg FROM not_moscow_citizens) AND town_to = 'Moscow'
GROUP BY ID_psg
HAVING COUNT(*) > 1;

