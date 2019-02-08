# Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
# Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

USE ships;

SELECT DISTINCT name
FROM
     (SELECT name
      FROM Ships
      UNION
      SELECT ship name
      FROM Outcomes) res
      WHERE name LIKE '% % %';