# Определите среднее число орудий для классов линейных кораблей.
# Получить результат с точностью до 2-х десятичных знаков.

USE ships;

SELECT CAST(AVG(numGuns * 1.0) AS DECIMAL(10, 2)) avg_n_guns
FROM Classes
WHERE type = 'bb';