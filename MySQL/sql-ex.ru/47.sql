# Пронумеровать строки из таблицы Product в следующем порядке:
# имя производителя в порядке убывания числа производимых им моделей
# (при одинаковом числе моделей имя производителя в алфавитном порядке по возрастанию),
# номер модели (по возрастанию).

# Вывод: номер в соответствии с заданным порядком, имя производителя (maker), модель (model)


USE computer;

SELECT ROW_NUMBER() OVER(ORDER BY nums DESC, maker, model) no,
       maker, model
FROM
     (SELECT p1.maker, model, nums
     FROM Product p1 LEFT JOIN
       (SELECT maker, COUNT(*) nums
       FROM Product
       GROUP BY maker) nums ON p1.maker = nums.maker) res
ORDER BY nums DESC, maker, model;
