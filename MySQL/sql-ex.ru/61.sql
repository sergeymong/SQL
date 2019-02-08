# Посчитать остаток денежных средств на всех пунктах
# приема для базы данных с отчетностью не чаще одного раза в день.

USE inc_out;

WITH inc_tot AS
       (SELECT SUM(inc) inc_t
        FROM Income_o
        WHERE inc IS NOT NULL),
     out_tot AS
       (SELECT SUM(`out`) outc_t
        FROM Outcome_o
        WHERE `out` IS NOT NULL)

SELECT COALESCE(inc_t, 0) - COALESCE(outc_t, 0) balance
FROM inc_tot, out_tot;