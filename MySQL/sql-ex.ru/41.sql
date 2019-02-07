# Для ПК с максимальным кодом из таблицы PC вывести все его характеристики (кроме кода) в два столбца:
# - название характеристики (имя соответствующего столбца в таблице PC);
# - значение характеристики

USE computer;

WITH max AS
  (SELECT *
  FROM PC
  WHERE code = (SELECT MAX(code) FROM PC))

SELECT 'model' name, model val
FROM max
UNION ALL
SELECT 'speed' name, speed val
FROM max
UNION ALL
SELECT 'ram' name, ram val
FROM max
UNION ALL
SELECT 'hd' name, hd val
FROM max
UNION ALL
SELECT 'cd' name, cd val
FROM max
UNION ALL
SELECT 'price' name, price val
FROM max;

