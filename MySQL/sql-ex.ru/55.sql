# Для каждого класса определите год, когда был спущен на воду первый корабль этого класса.
# Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска
# на воду кораблей этого класса. Вывести: класс, год.

USE ships;


SELECT res.class, min_d
FROM
     (SELECT class
      FROM Ships
      UNION
      SELECT class
      FROM Classes) res
       LEFT JOIN
       (SELECT class, MIN(launched) min_d
       FROM Ships
       GROUP BY class) min_d
         ON res.class = min_d.class;

