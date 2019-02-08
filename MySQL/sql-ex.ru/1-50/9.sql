# Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
SELECT DISTINCT maker
FROM PC pc INNER JOIN Product pr
  ON pc.model = pr.model
WHERE speed >= 450;
