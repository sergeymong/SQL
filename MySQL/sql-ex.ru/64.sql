# Используя таблицы Income и Outcome,
# для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот.
# Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день.

USE inc_out;

WITH res AS
       (SELECT i.point, i.date, SUM(i.inc) inc, SUM(o.`out`) outc
        FROM Income i LEFT JOIN Outcome o ON i.date = o.date AND i.point = o.point
        GROUP BY i.point, i.date
        UNION
        SELECT o.point, o.date, SUM(i.inc), SUM(o.`out`) outc
        FROM Outcome o LEFT JOIN Income i ON i.date = o.date AND i.point = o.point
        GROUP BY o.point, o.date)

SELECT DISTINCT point, date,
       CASE WHEN inc IS NOT NULL THEN 'inc' ELSE 'out' END type,
       CASE WHEN inc IS NOT NULL THEN inc ELSE outc END val
FROM res
WHERE inc IS NULL OR outc IS NULL;

