# Найдите средний размер диска ПК каждого
# из тех производителей, которые выпускают и принтеры.
# Вывести: maker, средний размер HD.


SELECT DISTINCT pro.maker, AVG(PC.hd)
FROM PC INNER JOIN Product pro
  on PC.model = pro.model
WHERE pro.maker IN (SELECT DISTINCT maker
  FROM Product WHERE type = 'Printer')
  GROUP BY pro.maker;
