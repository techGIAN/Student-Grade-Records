-- Query 4
-- The midterm results have arrived and you would like to display students' midterm marks (out of 45). You would like to give feedback as well,
-- based on the computed midterm_grade. If less than 60%, output "Needs Improvement"; if more than or equal to 80%, output "Keep It Up", and
-- otherwise "Good Enough". Since each assignment has an overall grade weight of 5% and the midterm is worth 30%, then the current midterm_grade
-- is calculated by weighing each assignment as 12.5% each and the midterm test to be worth 75%. This should be the schema:
-- (student_id, a1_score, a2_score, midterm_score, midterm_grade, feedback). Then sort by student_id.

SELECT *
FROM
(
    (
        SELECT *, "Needs Improvement" AS "feedback"
        FROM
        (
        SELECT T12.student_id,
            T12.a1_score,
            T12.a2_score,
            T_mid.midterm_score,
            CONCAT(FORMAT((T12.a1_score*0.125 + T12.a2_score*0.125 + T_mid.midterm_score*0.75), 2), '%') AS midterm_grade
        FROM
            (
            SELECT T1.student_id, T1.a1_score, T2.a2_score
            FROM
            (
                SELECT demographics.student_id,
                    CONCAT(FORMAT(a1.raw_score/15*100,2), '%') AS a1_score
                FROM demographics
                INNER JOIN a1 ON demographics.student_id = a1.student_id
            ) AS T1
            INNER JOIN 
            (
                SELECT demographics.student_id,
                    CONCAT(FORMAT(a2.raw_score/25*100,2), '%') AS a2_score
                FROM demographics
                INNER JOIN a2 ON demographics.student_id = a2.student_id
            ) AS T2
            ON T1.student_id = T2.student_id
            ) AS T12
        INNER JOIN (
            SELECT demographics.student_id,
                CONCAT(FORMAT(midterm.raw_score/45*100,2), '%') AS midterm_score
            FROM demographics
            INNER JOIN midterm ON demographics.student_id = midterm.student_id
        ) AS T_mid
        ON T12.student_id = T_mid.student_id
        ) AS T60
        WHERE T60.midterm_grade < 60
    ) UNION ALL (
        SELECT *, "Good Enough" AS "feedback"
        FROM
        (
        SELECT T12.student_id,
            T12.a1_score,
            T12.a2_score,
            T_mid.midterm_score,
            CONCAT(FORMAT((T12.a1_score*0.125 + T12.a2_score*0.125 + T_mid.midterm_score*0.75), 2), '%') AS midterm_grade
        FROM
            (
            SELECT T1.student_id, T1.a1_score, T2.a2_score
            FROM
            (
                SELECT demographics.student_id,
                    CONCAT(FORMAT(a1.raw_score/15*100,2), '%') AS a1_score
                FROM demographics
                INNER JOIN a1 ON demographics.student_id = a1.student_id
            ) AS T1
            INNER JOIN 
            (
                SELECT demographics.student_id,
                    CONCAT(FORMAT(a2.raw_score/25*100,2), '%') AS a2_score
                FROM demographics
                INNER JOIN a2 ON demographics.student_id = a2.student_id
            ) AS T2
            ON T1.student_id = T2.student_id
            ) AS T12
        INNER JOIN (
            SELECT demographics.student_id,
                CONCAT(FORMAT(midterm.raw_score/45*100,2), '%') AS midterm_score
            FROM demographics
            INNER JOIN midterm ON demographics.student_id = midterm.student_id
        ) AS T_mid
        ON T12.student_id = T_mid.student_id
        ) AS T80
        WHERE T80.midterm_grade < 80 AND T80.midterm_grade >= 60
    ) UNION ALL (
        SELECT *, "Keep It Up" AS "feedback"
        FROM
        (
        SELECT T12.student_id,
            T12.a1_score,
            T12.a2_score,
            T_mid.midterm_score,
            CONCAT(FORMAT((T12.a1_score*0.125 + T12.a2_score*0.125 + T_mid.midterm_score*0.75), 2), '%') AS midterm_grade
        FROM
            (
            SELECT T1.student_id, T1.a1_score, T2.a2_score
            FROM
            (
                SELECT demographics.student_id,
                    CONCAT(FORMAT(a1.raw_score/15*100,2), '%') AS a1_score
                FROM demographics
                INNER JOIN a1 ON demographics.student_id = a1.student_id
            ) AS T1
            INNER JOIN 
            (
                SELECT demographics.student_id,
                    CONCAT(FORMAT(a2.raw_score/25*100,2), '%') AS a2_score
                FROM demographics
                INNER JOIN a2 ON demographics.student_id = a2.student_id
            ) AS T2
            ON T1.student_id = T2.student_id
            ) AS T12
        INNER JOIN (
            SELECT demographics.student_id,
                CONCAT(FORMAT(midterm.raw_score/45*100,2), '%') AS midterm_score
            FROM demographics
            INNER JOIN midterm ON demographics.student_id = midterm.student_id
        ) AS T_mid
        ON T12.student_id = T_mid.student_id
        ) AS T100
        WHERE T100.midterm_grade < 100 AND T100.midterm_grade >= 80
    )
) AS bigTable
ORDER BY bigTable.student_id;

-- Here is a sample output for the first 10 records:
-- +------------+----------+----------+---------------+---------------+-------------------+
-- | student_id | a1_score | a2_score | midterm_score | midterm_grade | feedback          |
-- +------------+----------+----------+---------------+---------------+-------------------+
-- |  105492788 | 86.67%   | 92.00%   | 51.11%        | 60.67%        | Good Enough       |
-- |  110019694 | 73.33%   | 80.00%   | 28.89%        | 40.83%        | Needs Improvement |
-- |  112585242 | 73.33%   | 80.00%   | 77.78%        | 77.50%        | Good Enough       |
-- |  112933422 | 80.00%   | 84.00%   | 60.00%        | 65.50%        | Good Enough       |
-- |  115837634 | 73.33%   | 84.00%   | 44.44%        | 53.00%        | Needs Improvement |
-- |  121026116 | 73.33%   | 84.00%   | 40.00%        | 49.67%        | Needs Improvement |
-- |  124681830 | 86.67%   | 92.00%   | 57.78%        | 65.67%        | Good Enough       |
-- |  124973030 | 80.00%   | 84.00%   | 73.33%        | 75.50%        | Good Enough       |
-- |  135822943 | 73.33%   | 84.00%   | 68.89%        | 71.33%        | Good Enough       |
-- |  136277515 | 80.00%   | 88.00%   | 73.33%        | 76.00%        | Good Enough       |
-- +------------+----------+----------+---------------+---------------+-------------------+
-- 10 rows in set (0.00 sec)
