# Найдите названия всех кораблей в базе данных, начинающихся с буквы R.

USE ships;

SELECT DISTINCT name
FROM
     (SELECT name
      FROM Ships
      UNION
      SELECT ship name
      FROM Outcomes) res
      WHERE name LIKE 'R%';