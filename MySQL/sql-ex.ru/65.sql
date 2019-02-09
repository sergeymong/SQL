# Пронумеровать уникальные пары {maker, type} из Product, упорядочив их следующим образом:
# - имя производителя (maker) по возрастанию;
# - тип продукта (type) в порядке PC, Laptop, Printer.
# Если некий производитель выпускает несколько типов продукции, то выводить его имя только в первой строке;
# остальные строки для ЭТОГО производителя должны содержать пустую строку символов ('').

USE computer;


WITH
ord AS
  (SELECT 1 num, 'PC' types
  UNION ALL
  SELECT 2 num, 'Laptop' types
  UNION ALL
  SELECT 3 num, 'Printer' types),
dis_prod AS
  (SELECT DISTINCT maker, type
   FROM Product),
res AS
  (SELECT ROW_NUMBER() over (PARTITION BY maker ORDER BY maker, num) ord, maker, type
   FROM dis_prod p LEFT JOIN ord ON p.type = ord.types)

SELECT ROW_NUMBER() over (ORDER BY maker) ord,
       CASE WHEN res.ord > 1 THEN '' ELSE maker END makers,
       type
FROM res;

