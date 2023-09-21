-- Query 5
-- The TAs happened to be pretty quick about marking A3 and A4 that A4 has already been finished as soon as A3 was also finished. Seems like 
-- A3 lagged but A4 was really fast in terms of marking. Anyways, we will display those two additional columns (out of 20 and 30 respectively)
-- into our result from Query 4. However, we will not display the midterm_grade and feedback columns as those information are only relevant
-- during the midterm time of the course. But what instead we need to show aside from A3 and A4 scores is that how much points each student
-- needs in the coming final exam in order to pass the course. We are letting students know that the exam is out of 100. To pass the course,
-- the students must achieve an overall grade of 80%. If the student will pass the course regardless of whether they write the exam or not,
-- then output 0. If the student has no hope of passing regardless of their score in the exam, output -1. This will help the teacher know
-- if how many students will have a "-1", which means that the teacher will likely give an extra credit homework to boost their grades and
-- help them not to fail the course.

SELECT *
FROM
(
    (
        SELECT *,
            CEILING((80 - (T_pre_final.a1_score*0.05 + T_pre_final.a2_score*0.05 + T_pre_final.a3_score*0.05 + T_pre_final.a4_score*0.05 + T_pre_final.midterm_score*0.3))/0.5) AS points_required
        FROM
        (
            SELECT T_pre_midterm.student_id, 
                T_pre_midterm.a1_score,
                T_pre_midterm.a2_score,
                T_pre_midterm.midterm_score,
                T34.a3_score,
                T34.a4_score
            FROM
            (
                SELECT T12.student_id,
                        T12.a1_score,
                        T12.a2_score,
                        T_mid.midterm_score
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
            ) AS T_pre_midterm
            INNER JOIN (
                SELECT T3.student_id, T3.a3_score, T4.a4_score
                FROM
                (
                    SELECT demographics.student_id,
                        CONCAT(FORMAT(a3.raw_score/20*100,2), '%') AS a3_score
                    FROM demographics
                    INNER JOIN a3 ON demographics.student_id = a3.student_id
                ) AS T3
                INNER JOIN 
                (
                    SELECT demographics.student_id,
                        CONCAT(FORMAT(a4.raw_score/30*100,2), '%') AS a4_score
                    FROM demographics
                    INNER JOIN a4 ON demographics.student_id = a4.student_id
                ) AS T4
                ON T3.student_id = T4.student_id
            ) AS T34
            ON T_pre_midterm.student_id = T34.student_id
        ) AS T_pre_final
        WHERE CEILING((80 - (T_pre_final.a1_score*0.05 + T_pre_final.a2_score*0.05 + T_pre_final.a3_score*0.05 + T_pre_final.a4_score*0.05 + T_pre_final.midterm_score*0.3))/0.5) <= 100
    ) UNION ALL (
        SELECT *,
            -1 AS points_required
        FROM
        (
            SELECT T_pre_midterm.student_id, 
                T_pre_midterm.a1_score,
                T_pre_midterm.a2_score,
                T_pre_midterm.midterm_score,
                T34.a3_score,
                T34.a4_score
            FROM
            (
                SELECT T12.student_id,
                        T12.a1_score,
                        T12.a2_score,
                        T_mid.midterm_score
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
            ) AS T_pre_midterm
            INNER JOIN (
                SELECT T3.student_id, T3.a3_score, T4.a4_score
                FROM
                (
                    SELECT demographics.student_id,
                        CONCAT(FORMAT(a3.raw_score/20*100,2), '%') AS a3_score
                    FROM demographics
                    INNER JOIN a3 ON demographics.student_id = a3.student_id
                ) AS T3
                INNER JOIN 
                (
                    SELECT demographics.student_id,
                        CONCAT(FORMAT(a4.raw_score/30*100,2), '%') AS a4_score
                    FROM demographics
                    INNER JOIN a4 ON demographics.student_id = a4.student_id
                ) AS T4
                ON T3.student_id = T4.student_id
            ) AS T34
            ON T_pre_midterm.student_id = T34.student_id
        ) AS T_pre_final
        WHERE CEILING((80 - (T_pre_final.a1_score*0.05 + T_pre_final.a2_score*0.05 + T_pre_final.a3_score*0.05 + T_pre_final.a4_score*0.05 + T_pre_final.midterm_score*0.3))/0.5) > 100
    )
) AS final_table
ORDER BY final_table.student_id;

-- Here is a sample output for the first 10 records:
-- +------------+----------+----------+---------------+----------+----------+-----------------+
-- | student_id | a1_score | a2_score | midterm_score | a3_score | a4_score | points_required |
-- +------------+----------+----------+---------------+----------+----------+-----------------+
-- |  105492788 | 86.67%   | 92.00%   | 51.11%        | 75.00%   | 66.67%   |              98 |
-- |  110019694 | 73.33%   | 80.00%   | 28.89%        | 80.00%   | 63.33%   |              -1 |
-- |  112585242 | 73.33%   | 80.00%   | 77.78%        | 80.00%   | 50.00%   |              85 |
-- |  112933422 | 80.00%   | 84.00%   | 60.00%        | 65.00%   | 46.67%   |              97 |
-- |  115837634 | 73.33%   | 84.00%   | 44.44%        | 85.00%   | 53.33%   |              -1 |
-- |  121026116 | 73.33%   | 84.00%   | 40.00%        | 65.00%   | 43.33%   |              -1 |
-- |  124681830 | 86.67%   | 92.00%   | 57.78%        | 60.00%   | 46.67%   |              97 |
-- |  124973030 | 80.00%   | 84.00%   | 73.33%        | 75.00%   | 30.00%   |              90 |
-- |  135822943 | 73.33%   | 84.00%   | 68.89%        | 60.00%   | 53.33%   |              92 |
-- |  136277515 | 80.00%   | 88.00%   | 73.33%        | 55.00%   | 66.67%   |              88 |
-- +------------+----------+----------+---------------+----------+----------+-----------------+
-- 10 rows in set (0.00 sec)