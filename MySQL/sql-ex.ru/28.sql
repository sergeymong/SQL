# Используя таблицу Product,
# определить количество производителей, выпускающих по одной модели.


WITH result AS (
  SELECT maker
  FROM product
  GROUP BY maker
  HAVING COUNT(model) = 1
  )
SELECT COUNT(*) qty
FROM result;