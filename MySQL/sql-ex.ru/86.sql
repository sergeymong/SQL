# Для каждого производителя перечислить в алфавитном
# порядке с разделителем "/" все типы выпускаемой им продукции.
# Вывод: maker, список типов продукции

USE computer;

SELECT maker, GROUP_CONCAT(DISTINCT type ORDER BY type SEPARATOR '/') products
FROM Product
GROUP BY maker;