# Одной из характеристик корабля является
# половина куба калибра его главных орудий (mw).
# С точностью до 2 десятичных знаков
# определите среднее значение mw для кораблей каждой страны,
# у которой есть корабли в базе данных.

USE ships;

SELECT *
FROM Classes;

SELECT *
FROM Outcomes;

SELECT *
FROM Ships;

SELECT Country, CAST(AVG(bore*bore*bore)/2 AS DECIMAL(10, 2)) mw
FROM (SELECT c.country, bore
 FROM Classes C,
 Ships S
 WHERE S.class = C.Class AND
 NOT bore IS NULL
 UNION ALL
 SELECT country, bore
 FROM Classes C,
 OutComes O
 WHERE O.Ship = C.Class AND
 NOT EXISTS (SELECT 1
 FROM Ships S
 WHERE s.Name = O.Ship
 ) AND
 NOT bore IS NULL
 GROUP BY country, bore
 ) AS Q1
GROUP BY country;

# TODO Not finished, text of task awful. Try again sometime.




