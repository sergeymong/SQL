# Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).

USE ships;

SELECT name
FROM Ships s
WHERE s.name IN
      (SELECT class
        FROM Classes)
UNION
SELECT ship
FROM Outcomes o
WHERE o.ship IN
      (SELECT class
        FROM Classes);