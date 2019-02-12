# Найти производителей, которые выпускают только принтеры или только PC.
# При этом искомые производители PC должны выпускать не менее 3 моделей.

USE computer;

WITH res AS
       (SELECT maker, type, COUNT(*) models
        FROM Product
        GROUP BY maker, type)

SELECT maker
FROM res r1
WHERE (type = 'Printer') OR (type = 'PC' AND models >=3)
GROUP BY maker
HAVING (SELECT COUNT(type) FROM res r2 WHERE r1.maker = r2.maker) = 1;