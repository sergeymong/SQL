# Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

USE ships;

SELECT DISTINCT battle
FROM Outcomes o
WHERE ship
        IN (SELECT name
            FROM Ships s
            WHERE s.class = 'Kongo' AND s.name = o.ship);