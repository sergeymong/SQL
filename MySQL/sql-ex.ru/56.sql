# Для каждого класса определите
# число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

USE ships;

# v1
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
         WHERE result = 'sunk')

SELECT c.class, COUNT(*) sunked
FROM all_sh
  INNER JOIN Classes c
    ON all_sh.class = c.class
GROUP BY c.class
UNION
SELECT class, 0 sunked
FROM Classes
WHERE class NOT IN (SELECT class FROM all_sh)
ORDER BY class;



