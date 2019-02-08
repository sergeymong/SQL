# Для каждого корабля,
# участвовавшего в сражении при Гвадалканале (Guadalcanal),
# вывести название, водоизмещение и число орудий.

USE ships;

SELECT *
FROM Outcomes
WHERE battle = 'Guadalcanal';

SELECT *
FROM Ships;

SELECT name,
       (SELECT displacement
        FROM Classes c
        WHERE c.class = s.class) displacement,
       (SELECT numGuns
        FROM Classes c
        WHERE c.class = s.class) numGuns
FROM Ships s
WHERE name IN
  (SELECT ship
  FROM Outcomes
  WHERE battle = 'Guadalcanal')
UNION
SELECT class, displacement, numGuns
FROM Classes c
WHERE class IN
  (SELECT ship
  FROM Outcomes
  WHERE battle = 'Guadalcanal')
UNION
SELECT ship n, null d, null ng
FROM Outcomes
WHERE battle = 'Guadalcanal'
  AND ship NOT IN (SELECT name FROM ships)
  AND ship NOT IN (SELECT class FROM classes);
