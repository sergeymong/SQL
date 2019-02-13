# C точностью до двух десятичных знаков определить среднее количество краски на квадрате.

USE paint;

WITH
res AS (SELECT B_Q_ID, SUM(B_VOL) tot_col, COUNT(DISTINCT (SELECT V_COLOR FROM utV WHERE utV.V_ID = utB.B_V_ID))+1 cols
      FROM utB
      GROUP BY B_Q_ID)


SELECT AVG(tot_col/cols)
FROM res






