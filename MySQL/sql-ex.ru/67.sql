# Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
# Замечания.
# 1) A - B и B - A считать РАЗНЫМИ маршрутами.
# 2) Использовать только таблицу Trip

USE aero;

WITH res AS (SELECT CONCAT(town_from, ' - ' ,town_to) flight, COUNT(ID_comp) flights
FROM Trip
GROUP BY CONCAT(town_from, ' - ' ,town_to))

SELECT COUNT(*) res
FROM res
WHERE flights = (SELECT MAX(flights) FROM res)
GROUP BY flights;