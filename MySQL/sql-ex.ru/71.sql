# Найти тех производителей ПК, все модели ПК которых имеются в таблице PC.

USE computer;

SELECT maker
FROM Product p LEFT JOIN PC P2 on p.model = P2.model
WHERE p.type = 'PC'
GROUP BY maker
HAVING SUM(CASE WHEN code IS NULL THEN 1 ELSE 0 END) = 0;

