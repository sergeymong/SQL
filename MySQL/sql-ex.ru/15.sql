# Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(hd) >=2;