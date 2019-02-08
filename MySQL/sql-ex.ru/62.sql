# Посчитать остаток денежных средств
# на всех пунктах приема на начало дня 15/04/01
# для базы данных с отчетностью не чаще одного раза в день.


USE inc_out;

WITH inc_tot AS
       (SELECT SUM(inc) inc_t
        FROM Income_o
        WHERE date < '2001-04-15' AND inc IS NOT NULL),
     out_tot AS
       (SELECT SUM(`out`) outc_t
        FROM Outcome_o
        WHERE date < '2001-04-15' AND `out` IS NOT NULL)

SELECT COALESCE(inc_t, 0) - COALESCE(outc_t, 0) balance
FROM inc_tot, out_tot;