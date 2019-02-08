# В предположении, что приход и расход денег на каждом пункте
# приема фиксируется не чаще одного раза в день
# [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными
# (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.


SELECT i.point, i.date, i.inc, o.`out`
FROM Income_o i LEFt JOIN  Outcome_o o
  ON o.point = i.point AND o.date = i.date
UNION
SELECT o.point, o.date, i.inc, o.`out`
FROM Outcome_o o LEFT JOIN Income_o i
  ON o.point = i.point AND o.date = i.date
ORDER BY point;