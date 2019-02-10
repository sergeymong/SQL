# Для каждого сражения определить первый и последний день
# месяца,
# в котором оно состоялось.
# Вывод: сражение, первый день месяца, последний
# день месяца.
#
# Замечание: даты представить без времени в формате "yyyy-mm-dd".


USE ships;

SELECT name, LAST_DAY(date) + INTERVAL 1 DAY - INTERVAL 1 MONTH first_day, LAST_DAY(date) last_day
FROM Battles;