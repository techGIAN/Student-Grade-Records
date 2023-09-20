-- Query 1:
-- The teacher would like to gain some preliminary statistics about the class demographics. They would like to obtain 5 different tables.
-- The first three would simply be a two-column table where the first one is either [program_name, year, gender] and the second column is 
-- count. The fourth table is the same except that the first column is age and is instead bracketed using 4 bins. Finally, the fifth table
-- is a 5-column table with columns [mean, median, min, max, range] that only has 1 row that depicts the statistic for the class cgpa.
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

-- Table 3: Gender and Count (if we really want [M, F, O])
-- Extract first a table of [M, F] and sort by the descending order
-- Then append row O
-- SELECT demographics.gender,
--        count(demographics.gender) AS count
-- FROM demographics
-- WHERE demographics.gender <> 'O'
-- GROUP BY demographics.gender
-- ORDER BY demographics.gender DESC
SELECT demographics.gender,
       count(demographics.gender) AS count
FROM demographics
WHERE demographics.gender = 'O'
GROUP BY demographics.gender
ORDER BY demographics.gender DESC
;