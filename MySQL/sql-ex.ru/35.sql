# В таблице Product найти модели, которые состоят
# только из цифр или только из латинских букв (A-Z, без учета регистра).
# Вывод: номер модели, тип модели.

USE computer;

SELECT model, type
FROM Product
WHERE LOWER(model) REGEXP '^[0-9]*$|^[a-z]*$';


# Testing regexp
INSERT INTO Product (maker, model, type)
VALUES ('X', 'AaBe2f', 'PC');
INSERT INTO Product (maker, model, type)
VALUES ('X', 'Aa3e2f', 'PC');
INSERT INTO Product (maker, model, type)
VALUES ('X', 'AaBeqf', 'PC');
INSERT INTO Product (maker, model, type)
VALUES ('X', 'AaBeaaf', 'PC');

# check insert
SELECT *
FROM Product;

# delete inserted values
DELETE FROM Product
WHERE maker = 'X';
