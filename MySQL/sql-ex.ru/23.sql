# Найдите производителей, которые производили бы как ПК
# со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
# Вывести: Maker

SELECT res.maker
FROM (
  (SELECT DISTINCT maker
  FROM Product p
  INNER JOIN PC ON p.model = PC.model
  WHERE speed >= 750)
  UNION ALL
  (SELECT DISTINCT maker
  FROM Product p
  INNER JOIN Laptop ON p.model = Laptop.model
  WHERE speed >= 750)
) AS res
GROUP BY maker
HAVING COUNT(*) >= 2;



