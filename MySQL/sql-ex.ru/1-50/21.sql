# Найдите максимальную цену ПК, выпускаемых каждым производителем,
# у которого есть модели в таблице PC.
# Вывести: maker, максимальная цена.

SELECT P.maker, MAX(PC.price)
FROM PC INNER JOIN Product P on PC.model = P.model
GROUP BY P.maker;