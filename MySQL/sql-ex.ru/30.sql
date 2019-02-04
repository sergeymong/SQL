# В предположении, что приход и расход денег на каждом пункте приема
# фиксируется произвольное число раз (первичным ключом в таблицах является
# столбец code), требуется получить таблицу, в которой каждому пункту за
# каждую дату выполнения операций будет соответствовать одна строка.
# Вывод: point, date, суммарный расход пункта за день (out), суммарный
# приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).


SELECT i.point, i.date, SUM(i.inc) inc, SUM(o.`out`) outc
FROM Income i LEFT JOIN  Outcome o
  ON o.code = i.code
GROUP BY i.date, i.point
UNION
SELECT o.point, o.date, SUM(i.inc) inc, SUM(o.`out`) outc
FROM Outcome o LEFT JOIN Income i
  ON o.code = i.code
GROUP BY o.date, o.point
ORDER BY point;

select o.point, o.date, SUM(o.`out`) outc
from Outcome o
GROUP BY date, point;