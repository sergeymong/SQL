# На основании информации из таблицы Pass_in_Trip, для каждой авиакомпании определить:
# 1) количество выполненных перелетов;
# 2) число использованных типов самолетов;
# 3) количество перевезенных различных пассажиров;
# 4) общее число перевезенных компанией пассажиров.
# Вывод: Название компании, 1), 2), 3), 4).

USE aero;

WITH flyes
  AS (SELECT T.trip_no, CONCAT(DATE(date), ' ', TIME(time_out), ' ', T.trip_no) dt, plane, ID_psg, ID_comp
      FROM Pass_in_trip Pit INNER JOIN Trip T on Pit.trip_no = T.trip_no)

SELECT (SELECT name
        FROM Company c
        WHERE c.ID_comp = f.ID_comp) company,
        COUNT(DISTINCT dt) flyes,
        COUNT(DISTINCT plane) planes,
        COUNT(DISTINCT ID_psg) uniq_pass,
        COUNT(*) tot_pass
FROM flyes f
GROUP BY ID_comp;