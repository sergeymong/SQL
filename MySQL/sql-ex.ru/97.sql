# Отобрать из таблицы Laptop те строки, для которых выполняется следующее условие:
# значения из столбцов speed, ram, price, screen возможно расположить таким образом,
# что каждое последующее значение будет превосходить предыдущее в 2 раза или более.
# Замечание: все известные характеристики ноутбуков больше нуля.
# Вывод: code, speed, ram, price, screen.


USE computer;

WITH all_specs
  AS (SELECT code, speed val
      FROM Laptop
      UNION ALL
      SELECT code, ram val
      FROM Laptop
      UNION ALL
      SELECT code, price val
      FROM Laptop
      UNION ALL
      SELECT code, screen val
      FROM Laptop),
ordered AS (SELECT *, ROW_NUMBER() over (PARTITION BY code ORDER BY val) size_val
        FROM all_specs),
res
  AS (SELECT *,
       (SELECT val
       FROM ordered o1
       WHERE o1.size_val = o2.size_val - 1
         AND o1.code = o2.code) prev
      FROM ordered o2)

SELECT code, speed, ram, price, screen
FROM Laptop
WHERE code IN (SELECT code
              FROM res
              GROUP BY code
              HAVING SUM(IF(val/2 >= COALESCE(prev, 0), 1, 0)) = 4);


