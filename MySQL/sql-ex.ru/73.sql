# Для каждой страны определить сражения, в которых не участвовали корабли данной страны.
# Вывод: страна, сражение

USE ships;

WITH ships AS
       (SELECT ship, battle,
        CASE WHEN class IS NULL THEN ship ELSE class END class
        FROM Outcomes o
        LEFT JOIN Ships s ON o.ship = s.name)

SELECT o.country, o.battle
FROM (SELECT DISTINCT country, name battle FROM Battles, Classes) o LEFT JOIN
     (SELECT battle, country, COUNT(ship) ships
      FROM ships s LEFT JOIN Classes c ON s.class = c.class
      WHERE country IS NOT NULL
      GROUP BY country, battle) r ON o.battle = r.battle AND o.country = r.country
WHERE ships IS NULL;


SELECT *
FROM Battles;


SELECT o.country, o.battle
FROM (SELECT DISTINCT country, name battle FROM Battles, Classes) o LEFT JOIN
     (SELECT battle, country, COUNT(ship) ships
      FROM (SELECT ship, battle,
        CASE WHEN class IS NULL THEN ship ELSE class END class
        FROM Outcomes o
        LEFT JOIN Ships s ON o.ship = s.name) s LEFT JOIN Classes c ON s.class = c.class
      WHERE country IS NOT NULL
      GROUP BY country, battle) r ON o.battle = r.battle AND o.country = r.country
WHERE ships IS NULL;