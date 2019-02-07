# Найдите корабли, `сохранившиеся для будущих сражений`;
# т.е. выведенные из строя в одной битве (damaged),
# они участвовали в другой, произошедшей позже.

USE ships;

# v1 (not correct)
SELECT ship, MIN(date), MAX(date)
FROM Outcomes o, Battles b
WHERE o.battle = b.name
GROUP BY ship
HAVING COUNT(ship) >= 2
   AND
       (SELECT MIN(result)
         FROM Outcomes) = 'damaged'
    AND MIN(date) < MAX(date);

# v2 (not correct)
SELECT ship
FROM (SELECT res1.ship, min_date, max_date, res2.result min_result, res3.result max_result
      FROM
     (SELECT ship, MIN(date) min_date, MAX(date) max_date, COUNT(*) count
      FROM Outcomes o, Battles b
      WHERE o.battle = b.name
      GROUP BY ship) res1
       LEFT JOIN
       (SELECT ship, result, date
       FROM Outcomes o, Battles b
       WHERE o.battle = b.name) res2 ON res1.min_date = res2.date AND res1.ship = res2.ship
       LEFT JOIN
       (SELECT ship, result, date
       FROM Outcomes o, Battles b
       WHERE o.battle = b.name) res3 ON res1.max_date = res3.date AND res1.ship = res3.ship) res
WHERE min_result = 'damaged'
      AND min_date < max_date;


# v3 (correct!!!)
SELECT DISTINCT res1.ship
FROM
     (SELECT ship, date
      FROM Outcomes o, Battles b
      WHERE o.battle = b.name AND result = 'damaged') res1
       LEFT JOIN
       (SELECT ship, MAX(date) date
        FROM Outcomes o, Battles b
        WHERE o.battle = b.name
        GROUP BY ship) res2
         ON res1.ship = res2.ship
WHERE res1.date < res2.date;
