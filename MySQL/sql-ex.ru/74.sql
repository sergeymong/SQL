# Вывести классы всех кораблей России (Russia).
# Если в базе данных нет классов кораблей России, вывести классы для всех имеющихся в БД стран.
# Вывод: страна, класс

USE ships;

SELECT *
FROM(
SELECT
       CASE
         WHEN
           (SELECT COUNT(*)
           FROM Classes
           WHERE country = 'Russia') = 0 THEN country
         ELSE
           (SELECT c1.country
            FROM Classes c1
             WHERE c1.class = c2.class AND c1.country = 'Russia') END country,
       CASE
         WHEN
           (SELECT COUNT(*)
           FROM Classes
           WHERE country = 'Russia') = 0 THEN class
         ELSE
           (SELECT class
            FROM Classes c1
             WHERE c1.class = c2.class AND c1.country = 'Russia') END class
FROM Classes c2) res
WHERE country IS NOT NULL;

SELECT *
FROM Classes;