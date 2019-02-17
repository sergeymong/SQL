# Рассматриваются только таблицы Income_o и Outcome_o.
# Известно, что прихода/расхода денег в воскресенье не бывает.
# Для каждой даты прихода денег на каждом из пунктов
# определить дату инкассации по следующим правилам:
# 1. Дата инкассации совпадает с датой прихода,
# если в таблице Outcome_o нет записи о выдаче денег в эту дату на этом пункте.

# 2. В противном случае - первая возможная дата после даты прихода денег,
# которая не является воскресеньем и в Outcome_o не отмечена выдача денег
# сдатчикам вторсырья в эту дату на этом пункте.

# Вывод: пункт, дата прихода денег, дата инкассации.

USE inc_out;

WITH calendar
  AS (SELECT DATE_ADD((SELECT MIN(date) FROM Income_o),
    INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
      FROM
     (SELECT 0 num UNION ALL
       SELECT 1 num UNION ALL
       SELECT 2 num UNION ALL
       SELECT 3 num UNION ALL
       SELECT 4 num UNION ALL
       SELECT 5 num UNION ALL
       SELECT 6 num UNION ALL
       SELECT 7 num UNION ALL
       SELECT 8 num UNION ALL
       SELECT 9 num) ones
      CROSS JOIN
       (SELECT 0 num UNION ALL
       SELECT 10 num UNION ALL
       SELECT 20 num UNION ALL
       SELECT 30 num UNION ALL
       SELECT 40 num UNION ALL
       SELECT 50 num UNION ALL
       SELECT 60 num UNION ALL
       SELECT 70 num UNION ALL
       SELECT 80 num UNION ALL
       SELECT 90 num) tens
      CROSS JOIN
       (SELECT 0 num UNION ALL
       SELECT 100 num UNION ALL
       SELECT 200 num UNION ALL
       SELECT 300 num UNION ALL
       SELECT 400 num UNION ALL
       SELECT 500 num UNION ALL
       SELECT 600 num UNION ALL
       SELECT 700 num UNION ALL
       SELECT 800 num UNION ALL
       SELECT 900 num) hundreds
    WHERE DAYNAME(DATE_ADD((SELECT MIN(date) FROM Income_o),
            INTERVAL (ones.num + tens.num + hundreds.num) DAY)) != 'Sunday'),
tots
  AS (SELECT i.point, i.date inc_date, o.date outc_date
      FROM Income_o i
      LEFT JOIN Outcome_o o ON i.date = o.date AND i.point = o.point)

SELECT point,
       inc_date date,
       CASE
         WHEN outc_date IS NULL
           THEN inc_date
         ELSE
           (SELECT MIN(dt)
           FROM calendar c
           WHERE c.dt > t.inc_date
             AND c.dt NOT IN (SELECT date FROM Outcome_o t1 WHERE t.point = t1.point))
         END INC_date
FROM tots t;