# Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb')
# и имевшие когда-либо классы крейсеров ('bc').

USE ships;

SELECT country
FROM Classes
GROUP BY country
HAVING COUNT(DISTINCT type) = 2;
