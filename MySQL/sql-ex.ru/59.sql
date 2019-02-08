# Посчитать остаток денежных средств
# на каждом пункте приема для базы данных
# с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.

USE inc_out;
WITH outc AS (
  SELECT point, SUM(`out`) outc
  FROM Outcome_o
  WHERE `out` IS NOT NULL
  GROUP BY point),
inc AS (
  SELECT point, SUM(inc) inc
  FROM Income_o
  WHERE inc IS NOT NULL
  GROUP BY point)

SELECT inc.point, COALESCE(inc, 0) - COALESCE(outc, 0) balance
FROM inc LEFT JOIN outc ON inc.point = outc.point
UNION
SELECT outc.point, COALESCE(inc, 0) - COALESCE(outc, 0)
FROM outc LEFT JOIN inc ON inc.point = outc.point;
