# Выбрать все белые квадраты, которые окрашивались только из баллончиков,
# пустых к настоящему времени. Вывести имя квадрата

USE paint;

WITH sq_colors
  AS (SELECT (SELECT Q_NAME FROM utQ WHERE utQ.Q_ID = utB.B_Q_ID) sq_name,
             B_Q_ID,
             B_V_ID,
             (SELECT V_COLOR FROM utV WHERE utV.V_ID = utB.B_V_ID) col,
             B_VOL tot_vol
      FROM utB
      WHERE B_VOL = 255
         OR B_V_ID IN (SELECT B_V_ID
                      FROM utB
                      GROUP BY B_V_ID
                      HAVING SUM(B_VOL) = 255))

SELECT sq_name
FROM sq_colors
GROUP BY sq_name
HAVING SUM(tot_vol) = 765;
