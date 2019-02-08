# Определить названия всех кораблей из таблицы Ships,
# которые могут быть линейным японским кораблем,
# имеющим число главных орудий не менее девяти,
# калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн

USE ships;

SELECT s.name
FROM Ships s
  INNER JOIN Classes C
    on s.class = C.class
WHERE type = 'bb'
  AND country = 'Japan'
  AND (numGuns >= 9 OR numGuns IS NULL)
  AND (bore < 19 OR bore IS NULL)
  AND (displacement <= 65000 OR displacement IS NULL);