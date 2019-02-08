# Для каждого типа продукции и каждого производителя из таблицы Product
# c точностью до двух десятичных знаков найти процентное отношение числа
# моделей данного типа данного производителя к общему числу моделей этого производителя.
# Вывод: maker, type, процентное отношение числа моделей данного типа к общему числу моделей производителя

USE computer;


WITH res1 AS
  (SELECT p.maker, type, CAST(COUNT(*) / AVG(tot_models) * 100.0 AS DECIMAL(10, 2)) percent_in_prod_matr
  FROM Product p
    LEFT JOIN
    (SELECT maker, COUNT(*) tot_models
      FROM Product
      GROUP BY maker) tot ON tot.maker = p.maker
  GROUP BY p.maker, type),
res2 AS
  (SELECT maker, type, CAST(0.0 AS DECIMAL(10, 2)) zero_percent
  FROM (SELECT DISTINCT maker FROM Product) m, (SELECT DISTINCT type FROM Product) t)

SELECT res2.maker, res2.type,
       CASE WHEN percent_in_prod_matr IS NULL THEN res2.zero_percent ELSE res1.percent_in_prod_matr END p_i_pd
FROM res2
  LEFT JOIN res1
    ON res2.type = res1.type AND res2.maker = res1.maker
ORDER BY res2.maker, res2.type;