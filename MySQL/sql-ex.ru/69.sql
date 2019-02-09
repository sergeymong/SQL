# По таблицам Income и Outcome для каждого пункта приема найти остатки денежных средств на конец каждого дня,
# в который выполнялись операции по приходу и/или расходу на данном пункте.
# Учесть при этом, что деньги не изымаются, а остатки/задолженность переходят на следующий день.
# Вывод: пункт приема, день в формате "dd/mm/yyyy", остатки/задолженность на конец этого дня.


USE inc_out;

WITH
gr_inc AS
  (SELECT point, date, SUM(inc) inc
  FROM Income
  GROUP BY point, date),
gr_out AS
  (SELECT point, date, SUM(`out`) outc
  FROM Outcome
  GROUP BY point, date),
res AS
  (SELECT gr_inc.point, gr_inc.date, gr_inc.inc, gr_out.outc
  FROM gr_inc LEFT JOIN gr_out
    ON gr_inc.point = gr_out.point
         AND gr_inc.date = gr_out.date
  UNION
  SELECT gr_out.point, gr_out.date, gr_inc.inc, gr_out.outc
  FROM gr_out LEFT JOIN gr_inc
    ON gr_inc.point = gr_out.point
         AND gr_inc.date = gr_out.date)

SELECT point, DATE_FORMAT(date, '%d/%m/%Y') date,
       (SELECT SUM(COALESCE(inc, 0)) - SUM(COALESCE(outc, 0))
       FROM res r2
       WHERE r2.point = r1.point AND r2.date <= r1.date) tot_day_balance
FROM res r1
ORDER BY point, date;