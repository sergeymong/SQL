# Найти производителей, у которых больше всего моделей в таблице Product,
# а также тех, у которых меньше всего моделей.
# Вывод: maker, число моделей


USE computer;

EXPLAIN WITH makers_models
  AS (SELECT maker, COUNT(*) models
      FROM Product
      GROUP BY maker)

SELECT maker, models
FROM makers_models
WHERE models = (SELECT MAX(models) FROM makers_models) OR
      models = (SELECT MIN(models) FROM makers_models);


# v2. more effective
EXPLAIN WITH makers_models
  AS (SELECT maker, COUNT(*) models
      FROM Product
      GROUP BY maker)

SELECT maker, models
FROM makers_models mm1
  INNER JOIN
  (SELECT MAX(models) max, MIN(models) min
  FROM makers_models) mm2
    ON mm1.models = mm2.max
         OR mm1.models = mm2.min;




