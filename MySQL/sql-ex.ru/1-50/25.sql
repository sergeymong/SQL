# Найдите производителей принтеров,
# которые производят ПК с наименьшим объемом RAM и с
# самым быстрым процессором среди всех ПК,
# имеющих наименьший объем RAM. Вывести: Maker


SELECT DISTINCT maker
FROM Product p
INNER JOIN PC
  ON p.model = PC.model
WHERE ram = (SELECT MIN(ram) FROM PC)
  AND speed = (SELECT MAX(speed) FROM PC WHERE ram = (SELECT MIN(ram) FROM PC))
  AND maker IN (SELECT maker FROM product WHERE type='printer');

