# Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

USE ships;

SELECT *
FROM Ships;

SELECT name
FROM Battles b
WHERE NOT EXISTS
  (SELECT 1
  FROM Ships s
  WHERE s.launched = YEAR(b.date));