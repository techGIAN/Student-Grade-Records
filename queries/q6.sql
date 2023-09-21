-- Query 6:
-- The final exam is done and has now been marked. Now often, we do not release final exam grades and instead just the final grade.
-- We will do the same but this time sort it by final grade from highest to lowest to reveal the top students. Use the schema
-- (name, final_grade). Note that the final exam is worth 50% of the overall grade.

SELECT T_FIN.name,
        CONCAT(FORMAT(T_FIN.final_grade, 2), "%") AS final_grade
FROM
(
    SELECT T_first.name,
        -- T_first.student_id,  # show only names and grades
        --     T_first.a1_score,
        --     T_first.a2_score,
        --     T_first.midterm_score,
        --     T_last.a3_score,
        --     T_last.a4_score,
        --     T_last.final_exam_score,
            (T_first.a1_score*0.05 + T_first.a2_score*0.05 + T_last.a3_score*0.05 + T_last.a4_score*0.05 + T_first.midterm_score*0.3 + T_last.final_exam_score*0.5) AS final_grade
    FROM
    (
        SELECT T_somthing.student_id, 
            T_somthing.name,
            T_somthing.a1_score,
            T_somthing.a2_score,
            T_somthing.midterm_score
        FROM
        (
            SELECT T12.student_id,
                    T12.name,
                    T12.a1_score,
                    T12.a2_score,
                    T_mid.midterm_score
            FROM
                (
                SELECT T1.student_id, T1.name, T1.a1_score, T2.a2_score
                FROM
                (
                    SELECT demographics.student_id,
                        CONCAT(demographics.first_name, " ", demographics.last_name) AS name,
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
        ) AS T_somthing
    ) AS T_first
    INNER JOIN
    (
    SELECT T34.student_id, T34.a3_score, T34.a4_score, T_final_exam.final_exam_score
    FROM
    (
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
    INNER JOIN
    (
        SELECT demographics.student_id,
                CONCAT(final.raw_score, '%') AS final_exam_score
        FROM demographics
        INNER JOIN final ON demographics.student_id = final.student_id
    ) AS T_final_exam
    ON T34.student_id = T_final_exam.student_id
    ) AS T_last
    ON T_first.student_id = T_last.student_id
) AS T_FIN
ORDER BY T_FIN.final_grade DESC;

-- Here is a sample output for the first 10 records:
-- +--------------------+-------------+
-- | name               | final_grade |
-- +--------------------+-------------+
-- | Linda Prince       | 73.55%      |
-- | Victoria Campbell  | 73.25%      |
-- | Gregory Mayer      | 73.07%      |
-- | Douglas Bennett    | 72.67%      |
-- | Doris Perry        | 72.20%      |
-- | Joe Jefferson      | 71.57%      |
-- | Stephanie Santiago | 70.00%      |
-- | Kelly Kerr         | 69.98%      |
-- | Virginia Sanchez   | 69.88%      |
-- | Donald Harrison    | 69.83%      |
-- +--------------------+-------------+
-- 10 rows in set (0.00 sec)


