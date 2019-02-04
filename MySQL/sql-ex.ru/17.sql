# Найдите модели ПК-блокнотов, скорость которых меньше скорости любого из ПК.
# Вывести: type, model, speed

SELECT DISTINCT 'Laptop' type, model, speed
FROM Laptop
WHERE speed < ALL(
SELECT DISTINCT speed
FROM PC);