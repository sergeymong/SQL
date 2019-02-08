# Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

SELECT DISTINCT pr.maker, cp.price
FROM Product pr INNER JOIN (SELECT model, price
FROM Printer
WHERE color = 'y'
AND price = (SELECT
  MIN(PRICE)
FROM Printer
WHERE color = 'y')) AS cp ON pr.model = cp.model;