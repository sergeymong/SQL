# Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

USE ships;

SELECT class, name,
       (SELECT country
        FROM Classes c
        WHERE s.class = c.class) country
FROM Ships s
WHERE
      EXISTS
        (SELECT 1
        FROM Classes c
        WHERE s.class = c.class
          AND c.numGuns >= 10
        );

