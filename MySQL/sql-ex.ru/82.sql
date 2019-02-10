# В наборе записей из таблицы PC,
# отсортированном по столбцу code (по возрастанию)
# найти среднее значение цены для каждой шестерки подряд идущих ПК.
# Вывод: значение code, которое является первым в наборе из шести строк, среднее значение цены в наборе.

USE computer;


WITH some AS (
  SELECT code, price, ROW_NUMBER() over (ORDER BY code)
  FROM PC)

SELECT p1.code, AVG(p2.price) avg
FROM PC p1 JOIN some p2 ON (p2.code - p1.code) < 6 AND (p2.code - p1.code) >= 0
GROUP BY p1.code
HAVING COUNT(p1.code) = 6;