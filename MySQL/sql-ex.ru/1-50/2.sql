# Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer';