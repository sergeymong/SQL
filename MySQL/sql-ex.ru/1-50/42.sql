# Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.

USE ships;

SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk'
