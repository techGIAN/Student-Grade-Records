-- Query 1:
-- The first assignment has just been marked by the TA. You would like to display the assignment results to the class
-- according to the following schema:
-- (student_id, name, a1_score)
-- where name is the concatenation of the student's first and last name separated by a space
--       a1_score is the percentage score of the student for a1 (out of 15)
-- To make it more convenient and much easier for students to look up their name, you display the results arranged chronologically by last name.

SELECT demographics.student_id,
       CONCAT(demographics.first_name, ' ', demographics.last_name) AS name,
       CONCAT(FORMAT(a1.raw_score/15*100,2), '%') AS a1_score
FROM demographics
INNER JOIN a1 ON demographics.student_id = a1.student_id
ORDER BY demographics.last_name;

-- Here is a sample output for the first 10 records:
-- +------------+--------------------+----------+
-- | student_id | name               | a1_score |
-- +------------+--------------------+----------+
-- |  611481869 | Sandra Acosta      | 73.33%   |
-- |  201254718 | Danielle Alexander | 86.67%   |
-- |  877197653 | Logan Alexander    | 93.33%   |
-- |  383230831 | Carol Ali          | 80.00%   |
-- |  915714920 | Joshua Anderson    | 73.33%   |
-- |  226303555 | Debra Arroyo       | 86.67%   |
-- |  750002093 | Andrea Arroyo      | 73.33%   |
-- |  276936575 | Theresa Atkinson   | 73.33%   |
-- |  677974469 | Doris Avalos       | 80.00%   |
-- |  996675949 | Jose Avery         | 86.67%   |
-- +------------+--------------------+----------+
-- 10 rows in set (0.00 sec)