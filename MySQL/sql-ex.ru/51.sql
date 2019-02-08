# Найдите названия кораблей, имеющих
# наибольшее число орудий среди всех
# имеющихся кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).


USE ships;

# v1 (not work in sql-ex)
WITH sel AS
       (SELECT class, numGuns, displacement
       FROM Classes
       ORDER BY displacement),
     all_sh AS
       (SELECT name, class
       FROM Ships
       UNION
       SELECT ship name, ship class
       FROM Outcomes o
       WHERE ship IN (SELECT DISTINCT class FROM Classes)),
     res AS
       (SELECT all_sh.name, all_sh.class, sel.numGuns, sel.displacement
       FROM all_sh
         LEFT JOIN sel ON all_sh.class = sel.class),
     guns AS
       (SELECT displacement, MAX(numGuns) max_guns
       FROM sel
       GROUP BY displacement)

SELECT name
FROM res, guns
WHERE res.numGuns = guns.max_guns AND res.displacement = guns.displacement;


# v2
SELECT DISTINCT name
FROM (SELECT displacement, MAX(numGuns) max_guns
       FROM Classes
       GROUP BY displacement) guns,
     (SELECT all_sh.name, all_sh.class, sel.numGuns, sel.displacement
       FROM
            (SELECT name, class
            FROM Ships
            UNION
            SELECT ship name, ship class
            FROM Outcomes o
            WHERE ship IN (SELECT DISTINCT class FROM Classes)
            UNION
            SELECT class name, class
            FROM Classes) all_sh
              LEFT JOIN
              (SELECT class, numGuns, displacement
              FROM Classes) sel ON all_sh.class = sel.class) res
WHERE (res.numGuns = guns.max_guns AND res.displacement = guns.displacement)
  AND (res.numGuns IS NOT NULL AND res.displacement IS NOT NULL);

# v3
SELECT name
FROM (SELECT all_sh.name, c.numGuns, c.displacement
       FROM
            (SELECT name, class
            FROM Ships
            UNION
            SELECT ship name, ship class
            FROM Outcomes) all_sh
              JOIN Classes c ON all_sh.class = c.class) res
WHERE numGuns =
      (SELECT MAX(numGuns) max_guns
       FROM
            (SELECT all_sh.name, c.numGuns, c.displacement
            FROM
                 (SELECT name, class
                  FROM Ships
                  UNION
                  SELECT ship name, ship class
                  FROM Outcomes) all_sh JOIN Classes c ON all_sh.class = c.class) c
       WHERE res.displacement = c.displacement
       GROUP BY displacement);

# v4
WITH res AS
  (SELECT all_sh.name, c.numGuns, c.displacement
   FROM
      (SELECT name, class
      FROM Ships
      UNION
      SELECT ship name, ship class
      FROM Outcomes) all_sh JOIN
        Classes c ON all_sh.class = c.class)

SELECT name
FROM  res
WHERE numGuns =
      (SELECT MAX(numGuns) max_guns
       FROM res c
       WHERE res.displacement = c.displacement
       GROUP BY displacement);

