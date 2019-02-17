# При условии, что баллончики с красной краской использовались
# более одного раза, выбрать из них такие, которыми окрашены квадраты, имеющие голубую компоненту.
# Вывести название баллончика

USE paint;

WITH more_one_ballons
  AS (SELECT B_V_ID
      FROM utB
      WHERE B_V_ID IN (SELECT V_ID FROM utV WHERE V_COLOR = 'R')
      GROUP BY B_V_ID
      HAVING COUNT(*) > 1)

SELECT V_NAME
FROM utV
WHERE V_ID IN
      (SELECT B_V_ID
      FROM utB
      WHERE B_Q_ID IN
            (SELECT B_Q_ID
             FROM utB LEFT JOIN utV uV on utB.B_V_ID = uV.V_ID
             GROUP BY B_Q_ID
             HAVING MIN(uV.V_COLOR) = 'B'))
AND V_ID IN (SELECT * FROM more_one_ballons);


SELECT SUM()


