# Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT maker
FROM product
WHERE type = 'PC'
EXCEPT
SELECT maker
FROM product
WHERE type = 'Laptop';
