# Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.

USE ships;

SELECT class
FROM
  (SELECT name, class
   FROM Ships s, Outcomes o
   WHERE s.name = o.ship AND o.result = 'sunk'
   UNION
   SELECT ship name, ship class
   FROM Outcomes
   WHERE result = 'sunk' AND ship IN (SELECT class FROM Classes)) res
GROUP BY class
HAVING COUNT(*) >=1;
