# Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).

USE ships;

SELECT *
FROM Ships;

SELECT *
FROM Outcomes;

SELECT ship, ship class
FROM Outcomes
WHERE ship IN
      (SELECT class
        FROM Classes);

SELECT class
FROM
     (SELECT DISTINCT name, class
     FROM Ships
     UNION ALL
     SELECT DISTINCT ship, ship class
     FROM Outcomes
     WHERE ship IN (SELECT class FROM Classes)
       AND (ship NOT IN (SELECT name
     FROM Ships))) res
GROUP BY class
HAVING COUNT(class) = 1;


