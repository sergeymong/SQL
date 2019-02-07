# Одной из характеристик корабля является
# половина куба калибра его главных орудий (mw).
# С точностью до 2 десятичных знаков
# определите среднее значение mw для кораблей каждой страны,
# у которой есть корабли в базе данных.

USE ships;

SELECT country, CAST(AVG(POWER(bore, 3) / 2) AS DECIMAL(10, 2)) mw
FROM
     (SELECT name, class
      FROM Ships
      UNION
      SELECT ship name, ship class
      FROM Outcomes
      WHERE ship IN (SELECT class FROM Classes)) res
       LEFT JOIN Classes c
         ON res.class = c.class
GROUP BY c.country;

# DID IT THROUGH 5 DAYS !!!




