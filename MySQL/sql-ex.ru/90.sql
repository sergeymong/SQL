# Вывести все строки из таблицы Product,
# кроме трех строк с наименьшими номерами моделей и трех строк с наибольшими номерами моделей.

USE computer;

WITH res
  AS(SELECT *, @rows := ROW_NUMBER() over (ORDER BY model) row_num
      FROM Product
      ORDER BY model)
SELECT maker, model, type
FROM res
WHERE row_num BETWEEN (SELECT MIN(row_num)+3 FROM res) AND (SELECT @rows - 3);