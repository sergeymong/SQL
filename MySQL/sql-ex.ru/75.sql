# Для каждого корабля из таблицы Ships указать название первого по времени сражения из таблицы Battles,
# в котором корабль мог бы участвовать после спуска на воду. Если год спуска на воду неизвестен,
# взять последнее по времени сражение.
# Если нет сражения, произошедшего после спуска на воду корабля, вывести NULL вместо названия сражения.
# Считать, что корабль может участвовать во всех сражениях, которые произошли в год спуска на воду корабля.
# Вывод: имя корабля, год спуска на воду, название сражения
#
# Замечание: считать, что не существует двух битв, произошедших в один и тот же день.

USE ships;

WITH sh_bat AS
       (SELECT name,
       launched,
       CASE
         WHEN launched IS NULL
          THEN (SELECT MAX(date)
        FROM Battles b)
       ELSE
       (SELECT MIN(date)
        FROM Battles b
        WHERE YEAR(b.date) >= s.launched) END can_battle
        FROM Ships s)

SELECT sh_bat.name ship, launched, b.name battle
FROM sh_bat LEFT JOIN Battles b ON sh_bat.can_battle = b.date;