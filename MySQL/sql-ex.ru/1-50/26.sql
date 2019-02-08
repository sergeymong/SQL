# Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A
# (латинская буква). Вывести: одна общая средняя цена.


WITH res AS (
SELECT p.maker, PC.price, PC.model
FROM PC INNER JOIN product p
  ON PC.model = p.model
WHERE p.maker = 'A'
UNION ALL
SELECT p.maker, l.price, l.model
FROM Laptop l INNER JOIN product p
  ON l.model = p.model
WHERE p.maker = 'A')
SELECT AVG(price)
FROM res;

