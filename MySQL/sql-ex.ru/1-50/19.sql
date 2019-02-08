# Для каждого производителя, имеющего модели в таблице Laptop,
# найдите средний размер экрана выпускаемых им ПК-блокнотов.
# Вывести: maker, средний размер экрана.

SELECT p.maker, AVG(screen)
FROM Product p INNER JOIN Laptop l 
   ON p.model = l.model
GROUP BY maker;