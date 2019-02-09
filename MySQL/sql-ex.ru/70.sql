# Укажите сражения, в которых участвовало по меньшей мере три корабля одной и той же страны.

USE ships;

WITH ships AS
       (SELECT ship, battle,
        CASE WHEN class IS NULL THEN ship ELSE class END class
        FROM Outcomes o
        LEFT JOIN Ships s ON o.ship = s.name)

SELECT DISTINCT battle
FROM ships s LEFT JOIN Classes c ON s.class = c.class
WHERE country IS NOT NULL
GROUP BY battle, country
HAVING COUNT(*) >= 3;