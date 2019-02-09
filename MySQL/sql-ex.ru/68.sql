# Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
# Замечания.
# 1) A - B и B - A считать ОДНИМ И ТЕМ ЖЕ маршрутом.
# 2) Использовать только таблицу Trip

USE aero;

WITH un_trip
  AS (SELECT ID_comp,
          CASE WHEN town_from < town_to THEN town_from ELSE town_to END town_from,
          CASE WHEN town_from < town_to THEN town_to ELSE town_from END town_to
      FROM Trip),
res AS (SELECT CONCAT(town_from, ' - ' ,town_to) flight, COUNT(ID_comp) flights
FROM un_trip
GROUP BY CONCAT(town_from, ' - ' ,town_to))

SELECT COUNT(*) res
FROM res
WHERE flights = (SELECT MAX(flights) FROM res)
GROUP BY flights;