# Определить названия всех кораблей из таблицы Ships, которые удовлетворяют,
# по крайней мере, комбинации любых четырёх критериев из следующего списка:
# numGuns = 8
# bore = 15
# displacement = 32000
# type = bb
# launched = 1915
# class=Kongo
# country=USA

USE ships;

SELECT name
FROM Ships s LEFT JOIN Classes c on s.class = c.class
WHERE
      IF(numGuns = 8, 1, 0) +
      IF(bore = 15, 1, 0) +
      IF(displacement = 32000, 1, 0) +
      IF(type = 'bb', 1, 0) +
      IF(launched = 1915, 1, 0) +
      IF(s.class = 'Kongo', 1, 0) +
      IF(country = 'USA', 1, 0) >=4;


