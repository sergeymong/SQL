# В предположении, что приход и расход денег на каждом пункте приема
# фиксируется произвольное число раз (первичным ключом в таблицах является
# столбец code), требуется получить таблицу, в которой каждому пункту за
# каждую дату выполнения операций будет соответствовать одна строка.
# Вывод: point, date, суммарный расход пункта за день (out), суммарный
# приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).

USE inc_out;
SELECT i.point, i.date, outcome, inc
FROM
     (SELECT point, date, SUM(inc) inc
     FROM Income
     GROUP BY point, date) i
       LEFT JOIN (SELECT point, date, SUM(`out`) outcome
       FROM Outcome
       GROUP BY point, date) o on i.date = o.date AND i.point = o.point
UNION
SELECT o.point, o.date, outcome, inc
FROM (SELECT point, date, SUM(`out`) outcome
       FROM Outcome
       GROUP BY point, date) o
       LEFT JOIN (SELECT point, date, SUM(inc) inc
     FROM Income
     GROUP BY point, date) i on i.date = o.date AND i.point = o.point;

# helping queries
SELECT point, date, SUM(`out`)
FROM Outcome
GROUP BY point, date;

SELECT point, date, SUM(inc)
FROM Income
GROUP BY point, date;