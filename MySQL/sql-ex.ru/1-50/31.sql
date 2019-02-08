# Для классов кораблей,
# калибр орудий которых не менее 16 дюймов, укажите класс и страну.

USE ships;

SELECT class, country
FROM Classes
WHERE bore >= 16;