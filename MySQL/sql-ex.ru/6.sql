# Для каждого производителя, выпускающего ПК-блокноты
# c объёмом жесткого диска не менее 10 Гбайт, найти
# скорости таких ПК-блокнотов. Вывод: производитель, скорость.

SELECT DISTINCT Product.maker, Laptop.speed
FROM Laptop LEFT JOIN
Product ON Laptop.model = Product.model
WHERE hd >=10
ORDER BY Product.maker;
