# По Вашингтонскому международному договору от начала 1922 г. запрещалось строить
# линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие
# этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.

USE ships;

SELECT *
FROM Ships;


SELECT *
FROM Classes;

SELECT s.name
FROM Ships s, Classes c
WHERE s.class = c.class
      AND (s.launched >= 1922 AND displacement > 35000)
      AND s.launched IS NOT NULL
      AND c.type = 'bb';
