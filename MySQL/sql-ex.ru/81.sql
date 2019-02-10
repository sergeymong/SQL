# Из таблицы Outcome получить
# все записи за тот месяц (месяцы),
# с учетом года, в котором суммарное значение расхода (out) было максимальным.

USE inc_out;

WITH
tots
  AS (SELECT EXTRACT(YEAR_MONTH FROM date) mo, SUM(`out`) tot
      FROM Outcome
      GROUP BY EXTRACT(YEAR_MONTH FROM date))

SELECT *
FROM Outcome
WHERE EXTRACT(YEAR_MONTH FROM date)
        IN
      (SELECT mo
       FROM tots
       WHERE tot = (SELECT MAX(tot) FROM tots));