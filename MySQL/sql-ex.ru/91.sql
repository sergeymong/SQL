# C точностью до двух десятичных знаков определить среднее количество краски на квадрате.

USE paint;


SELECT AVG(su)
FROM(
      SELECT Q_NAME, AVG(B_VOL) av, SUM(B_VOL) su
      FROM utB LEFT JOIN utV uV on utB.B_V_ID = uV.V_ID LEFT JOIN utQ uQ on utB.B_Q_ID = uQ.Q_ID
      GROUP BY Q_NAME, V_COLOR) res;

SELECT *, @middlevalue
FROM utQ;

ROW


