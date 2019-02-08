# С точностью до 2-х десятичных знаков определите
# среднее число орудий всех линейных кораблей (учесть корабли из таблицы Outcomes).

USE ships;

WITH res AS(
  SELECT c.*
  FROM
       (SELECT name, class
         FROM Ships
         UNION
         SELECT ship name, ship class
         FROM Outcomes) all_sh
         INNER JOIN Classes c ON all_sh.class = c.class
)

SELECT CAST(AVG(numGuns * 1.0) AS DECIMAL(10, 2)) avg_n_guns
FROM res
WHERE type = 'bb';