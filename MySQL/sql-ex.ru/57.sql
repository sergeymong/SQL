# Для классов, имеющих потери
# в виде потопленных кораблей и не менее 3 кораблей в базе данных,
# вывести имя класса и число потопленных кораблей.

USE ships;

WITH all_sh AS
       (SELECT res.name ship,
               CASE
                 WHEN res.class IS NOT NULL
                   THEN res.class
                 ELSE res.class_m
                 END class,
               result
       FROM
       (SELECT o.name, class_m, result, s.class
       FROM
            (SELECT ship name, ship class_m, result
            FROM Outcomes) o
              LEFT JOIN Ships s ON o.name = s.name) res
         WHERE result = 'sunk'),
more_3 AS
  (SELECT class
  FROM(
      SELECT name, class
      FROM Ships
      UNION
      SELECT ship name, ship name
      FROM Outcomes
      WHERE ship IN (SELECT class FROM Classes)) res
  GROUP BY class
  HAVING COUNT(*) >= 3)

SELECT c.class, COUNT(*) sunked
FROM all_sh
  INNER JOIN Classes c
    ON all_sh.class = c.class
GROUP BY c.class
HAVING c.class IN (SELECT * FROM more_3);



