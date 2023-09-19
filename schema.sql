USE mysql;

SET GLOBAL local_infile = true;

-- Create the Demographics table of students if it doesn't exist
DROP TABLE IF EXISTS demographics;
CREATE TABLE demographics (
    student_id int,
    first_name varchar(20),
    last_name varchar(20),
    program varchar(25),
    year_level int,
    email varchar(40),
    phone_num varchar(15),
    gender char(1),
    age int,
    cgpa float,
    PRIMARY KEY (student_id)
);

DROP TABLE IF EXISTS a1;
CREATE TABLE a1 (
    student_id int,
    raw_score float,
    PRIMARY KEY (student_id)
);
DROP TABLE IF EXISTS a2;
CREATE TABLE a2 (
    student_id int,
    raw_score float,
    PRIMARY KEY (student_id)
);
DROP TABLE IF EXISTS a3;
CREATE TABLE a3 (
    student_id int,
    raw_score float,
    PRIMARY KEY (student_id)
);
DROP TABLE IF EXISTS a4;
CREATE TABLE a4 (
    student_id int,
    raw_score float,
    PRIMARY KEY (student_id)
);
DROP TABLE IF EXISTS midterm;
CREATE TABLE midterm (
    student_id int,
    raw_score float,
    PRIMARY KEY (student_id)
);
DROP TABLE IF EXISTS final;
CREATE TABLE final (
    student_id int,
    raw_score float,
    PRIMARY KEY (student_id)
);
querie
-- Import the datasets from the CSVs
LOAD DATA LOCAL INFILE './data/demographic.csv'
INTO TABLE demographics
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './data/a1_scores.csv'
INTO TABLE a1
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './data/a2_scores.csv'
INTO TABLE a2
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './data/a3_scores.csv'
INTO TABLE a3
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './data/a4_scores.csv'
INTO TABLE a4
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './data/midterm_scores.csv'
INTO TABLE midterm
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE './data/final_exam_scores.csv'
INTO TABLE final
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Test the record count
SELECT count(*)
FROM demographics;

-- Check rows
SELECT *
FROM final;