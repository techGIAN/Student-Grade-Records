-- Query 1:
-- The teacher would like to gain some preliminary statistics about the class demographics. They would like to obtain 5 different tables.
-- The first three would simply be a two-column table where the first one is either [program_name, year, gender] and the second column is 
-- count. The fourth table is the same except that the first column is age and is instead bracketed using 4 bins. Finally, the fifth table
-- is a 5-column table with columns [mean, median, min, max, range] that only has 1 row that depicts the statistic for the class cgpa (format 2 dec).
-- Sort the results as follows: (T1) by count descending, (T2) by year ascending, (T3) according to [M,F,O], (T4) by age, (T5) by CGPA.

-- Table 1: Program and Count
SELECT demographics.program,
       count(demographics.program) AS count
FROM demographics
GROUP BY demographics.program
ORDER BY count DESC;

-- Here is a sample output for the first 10 records:
-- +-------------------------+-------+
-- | program                 | count |
-- +-------------------------+-------+
-- | Computer Science        |    17 |
-- | Computer Engineering    |    17 |
-- | Astronomy               |    16 |
-- | Electrical Engineering  |    16 |
-- | Mechanical Engineering  |    15 |
-- | Applied Statistics      |    15 |
-- | Artificial Intelligence |    14 |
-- | Software Development    |    13 |
-- | Physics                 |    13 |
-- | Digital Media           |    13 |
-- +-------------------------+-------+
-- 10 rows in set (0.00 sec)

-- Table 2: Year and Count
SELECT demographics.year_level AS year,
       count(demographics.year_level) AS count
FROM demographics
GROUP BY demographics.year_level
ORDER BY year_level;

-- Here is a sample output:
-- +------+-------+
-- | year | count |
-- +------+-------+
-- |    1 |    15 |
-- |    2 |    59 |
-- |    3 |   138 |
-- |    4 |    38 |
-- +------+-------+
-- 4 rows in set (0.00 sec)

-- Table 3: Gender and Count (if we really want [M, F, O] but it is default like that according to the data)
-- Extract first a table of [M, F] and sort by the descending order
-- Then append row O
-- This method will do it exactly as required
(
    SELECT demographics.gender,
       count(demographics.gender) AS count
    FROM demographics
    WHERE demographics.gender <> 'O'
    GROUP BY demographics.gender
    ORDER BY demographics.gender DESC
) UNION ALL (
    SELECT demographics.gender,
        count(demographics.gender) AS count
    FROM demographics
    WHERE demographics.gender = 'O'
    GROUP BY demographics.gender
);

-- Here is a sample output:
-- +--------+-------+
-- | gender | count |
-- +--------+-------+
-- | M      |   113 |
-- | F      |   112 |
-- | O      |    25 |
-- +--------+-------+
-- 3 rows in set (0.00 sec)

-- Table 4: Binned Ages and Count
(
    SELECT CONCAT('[', GROUP_CONCAT(age_table_41.age ORDER BY age_table_41.age ASC), ']') AS age,
           SUM(count) AS count
    FROM (
        SELECT demographics.age,
            count(demographics.age) AS count
        FROM demographics
        WHERE demographics.age >= 18 AND demographics.age < 21
        GROUP BY demographics.age
        ORDER BY demographics.age
    ) AS age_table_41
) UNION ALL (
    SELECT CONCAT('[', GROUP_CONCAT(age_table_42.age ORDER BY age_table_42.age ASC), ']') AS age,
           SUM(count) AS count
    FROM (
        SELECT demographics.age,
            count(demographics.age) AS count
        FROM demographics
        WHERE demographics.age >= 21 AND demographics.age < 24
        GROUP BY demographics.age
        ORDER BY demographics.age
    ) AS age_table_42
) UNION ALL (
    SELECT CONCAT('[', GROUP_CONCAT(age_table_43.age ORDER BY age_table_43.age ASC), ']') AS age,
           SUM(count) AS count
    FROM (
        SELECT demographics.age,
            count(demographics.age) AS count
        FROM demographics
        WHERE demographics.age >= 24 AND demographics.age < 27
        GROUP BY demographics.age
        ORDER BY demographics.age
    ) AS age_table_43
) UNION ALL (
    SELECT CONCAT('[', GROUP_CONCAT(age_table_44.age ORDER BY age_table_44.age ASC), ']') AS age,
           SUM(count) AS count
    FROM (
        SELECT demographics.age,
            count(demographics.age) AS count
        FROM demographics
        WHERE demographics.age >= 27 AND demographics.age <= 30
        GROUP BY demographics.age
        ORDER BY demographics.age
    ) AS age_table_44
);

-- Here is a sample output:
-- +---------------+-------+
-- | age           | count |
-- +---------------+-------+
-- | [18,19,20]    |    23 |
-- | [21,22,23]    |    79 |
-- | [24,25,26]    |    94 |
-- | [27,28,29,30] |    54 |
-- +---------------+-------+
-- 4 rows in set (0.00 sec)

-- Table 5: CGPA Statistics
SELECT FORMAT(AVG(T1.mean), 2) AS mean,
       FORMAT(AVG(T1.cgpa), 2) AS median,
       FORMAT(AVG(T1.min), 2) AS min,
       FORMAT(AVG(T1.max), 2) AS max,
       FORMAT((AVG(T1.max) - AVG(T1.min)), 2) AS 'range'
FROM
(
    SELECT T.mean, T.cgpa, T.min, T.max
    FROM (
        SELECT prelim_stat_table.mean, prelim_stat_table.min, prelim_stat_table.max, sort_table.first_name, sort_table.cgpa, prelim_stat_table.median_pos, prelim_stat_table.parity_comp, ROW_NUMBER() OVER w as row_num
        FROM (
            SELECT demographics.first_name, demographics.cgpa AS cgpa
            FROM demographics
            ORDER BY demographics.cgpa
        ) AS sort_table,
        (
            SELECT FORMAT(AVG(demographics.cgpa), 2) AS mean,
                    FORMAT(MIN(demographics.cgpa), 2) AS min,
                    FORMAT(MAX(demographics.cgpa), 2) AS max,
                    COUNT(demographics.cgpa) AS count,
                    COUNT(demographics.cgpa) MOD 2 AS parity,
                (COUNT(demographics.cgpa)+1) MOD 2 AS parity_opp,
                (COUNT(demographics.cgpa) MOD 2)*-1+2 AS parity_comp,
                    COUNT(demographics.cgpa) DIV 2 +1 AS median_pos,
                    (COUNT(demographics.cgpa) DIV 2) -  ((COUNT(demographics.cgpa)+1) MOD 2) AS offset_rows
            FROM demographics
        ) AS prelim_stat_table
        WINDOW w AS (ORDER BY sort_table.first_name)
        ORDER BY sort_table.cgpa
    ) AS T
    WHERE row_num <= T.median_pos AND row_num > (T.median_pos-T.parity_comp)
) AS T1;

-- Here is a sample output:
-- +------+--------+------+------+-------+
-- | mean | median | min  | max  | range |
-- +------+--------+------+------+-------+
-- | 7.48 | 7.58   | 5.80 | 8.93 | 3.13  |
-- +------+--------+------+------+-------+
-- 1 row in set (0.00 sec)