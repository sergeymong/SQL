# Вывести список ПК, для каждого из которых результат побитовой операции ИЛИ,
# примененной к двоичным представлениям скорости процессора и объема памяти,
# содержит последовательность из не менее четырех идущих подряд единичных битов.
# Вывод: код модели, скорость процессора, объем памяти.


USE computer;

WITH bins
  AS (SELECT code, CONV(speed, 10, 2) speed_bin, CONV(ram, 10, 2) ram_bin
      FROM PC)

SELECT code, speed, ram
FROM PC
WHERE code IN
      (SELECT code
       FROM bins
       WHERE speed_bin|ram_bin REGEXP '1111');
