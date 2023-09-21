-- Query 3:
-- The TA has finished marking the second assignment (out of 25). Compute the pre-term marks of each student. This is basically the mean of the
-- first two assignments that are equally weighted. The schema should be (student_id, a1_score, a2_score, pre_term). Note that we do not need to
-- include the name to maintain anonymity in class. The results will be released to the class, but only the ones who are in the "failing"
-- i.e., have a pre-term score of less than 78% (because the class is high standard) should be displayed so as to give these students a heads up
-- that they really need to study and prepare for the upcoming midterm test. Sort the results by student_id number so students can easily find 
-- whether they have to exert the extra effort for the coming midterm test.

SELECT *
FROM
    (
    SELECT T1.student_id, T1.a1_score, T2.a2_score, CONCAT(FORMAT(((T1.a1_score + T2.a2_score)/2), 2), '%') AS pre_term
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
    ) AS T
WHERE T.pre_term < 78
ORDER BY T.student_id;

-- Here is a sample output for the first 10 records:
-- +------------+----------+----------+----------+
-- | student_id | a1_score | a2_score | pre_term |
-- +------------+----------+----------+----------+
-- |  110019694 | 73.33%   | 80.00%   | 76.66%   |
-- |  112585242 | 73.33%   | 80.00%   | 76.66%   |
-- |  147105252 | 73.33%   | 76.00%   | 74.66%   |
-- |  158020985 | 73.33%   | 76.00%   | 74.66%   |
-- |  164357426 | 73.33%   | 80.00%   | 76.66%   |
-- |  165749503 | 66.67%   | 80.00%   | 73.34%   |
-- |  221778646 | 73.33%   | 76.00%   | 74.66%   |
-- |  224419444 | 73.33%   | 68.00%   | 70.66%   |
-- |  225243063 | 66.67%   | 80.00%   | 73.34%   |
-- |  226851210 | 66.67%   | 80.00%   | 73.34%   |
-- +------------+----------+----------+----------+
-- 10 rows in set (0.00 sec)