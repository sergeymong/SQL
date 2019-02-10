# Найти производителей компьютерной техники,
# у которых нет моделей ПК, не представленных в таблице PC.
# значит, все модели в PC

USE computer;

EXPLAIN SELECT maker
FROM Product p1
GROUP BY maker
HAVING
       COUNT(
         (SELECT model
         FROM Product p3
         WHERE type = 'PC'
           AND p1.model = p3.model))
               = COUNT(
                 (SELECT DISTINCT model
                 FROM PC p2
                 WHERE p1.model = p2.model));

