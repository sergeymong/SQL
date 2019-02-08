# Посчитать остаток денежных средств на начало
# дня 15/04/01 на каждом пункте приема для базы
# данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
# Замечание. Не учитывать пункты, информации о которых нет до указанной даты.

USE inc_out;

WITH inc_tot AS
       (SELECT point, SUM(inc) inc_t
        FROM Income_o
        WHERE date < '2001-04-15' AND inc IS NOT NULL
        GROUP BY point),
     out_tot AS
       (SELECT point, SUM(`out`) outc_t
        FROM Outcome_o
        WHERE date < '2001-04-15' AND `out` IS NOT NULL
        GROUP BY point)

SELECT inc_tot.point, COALESCE(inc_t, 0) - COALESCE(outc_t, 0) balance
FROM inc_tot LEFT JOIN out_tot ON inc_tot.point = out_tot.point
UNION
SELECT out_tot.point, COALESCE(inc_t, 0) - COALESCE(outc_t, 0) balance
FROM out_tot LEFT JOIN inc_tot ON inc_tot.point = out_tot.point;