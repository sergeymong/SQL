# Перечислите номера моделей любых типов,
# имеющих самую высокую цену по всей имеющейся в базе данных продукции.

SELECT
WITH all_products AS(
  SELECT model, price
  FROM PC
  UNION
  SELECT model, price
  FROM Laptop
  UNION
  SELECT model, price
  FROM Printer)
SELECT model
FROM all_products
WHERE price = (SELECT MAX(price) FROM all_products);