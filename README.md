# Student-Grade-Records
An SQL analysis for keeping and maintaining student's records in a course (made for teachers)

## Description
Maintaining records, such as their grades and demographics, of their students' class is one of the many duties teachers ought to do. Part of this is organizing these records. Many ways to organize such data is through the use of Excel or Google Sheets. Its use is powerful because not only does it allow for organization of data, it actually allows for other tasks as well including automation (i.e., automatically compute final grades based on inputted formulas), summarization (i.e., computing class average, standard deviation or some other statistical calculations to measure student performance), and visualization (i.e., illustrate through graphs, charts or plots the overall performance of the class based on calculated statistics). 

In this repository, instead of making use of Excel or Sheets to work with our data, let us make use of SQL. Our datasets are structured (as CSV files) and we can create a database and load such datasets as tables. And then we can query these tables so that we could obtain the results that we want. For example, as a teacher, I could use this to query which students have achieved a grade lower than 50% on a specific assignment? And after we have received the answer, the teacher can closely monitor these students and devise measures for how the students can improve their performance in future assessments (e.g., the teacher can give make-up classes, the teacher can give extra credit assignments, etc.). Of course, tasks such as these can be done using Excel but the exercise here is to be able to write SQL queries in order to achieve the results desired.

## Datasets
The datasets have been curated using the ```curator.py``` file. All datasets are synthetic, random and do not exist. For example, all names of individuals (students) are fake, and so are their contact information (email and phone numbers). Their grades are also not real, although random. Some specific attributes follow some distribution to make it more "realistic". Nevertheless, I present the following specifics of the data attributes.

### Demographic
Consists of the demographic profiles of students submitted by them to the teacher on Day 1.
* ```student_id```: A 9-digit randomly generated int (uniformly distributed between ```[100000000, 999999999]```. 
* ```first_name```: Student's first name; randomly generated from [https://www.ssa.gov/oact/babynames/decades/century.html](https://www.ssa.gov/oact/babynames/decades/century.html) - uniform distribution
* ```last_name```: Student's first name; randomly generated from [https://namecensus.com/last-names/](https://namecensus.com/last-names/) - uniform distribution
* ```program```: Student's program; randomly generated from ```['Computer Science', 'Computer Engineering', 'Electrical Engineering', 'Data Science', 'Artificial Intelligence', 'Computer Security', 'Digital Media', 'Mathematics', 'Applied Mathematics', 'Statistics', 'Applied Statistics', 'Software Development', 'Data Analytics', 'Physics', 'Biophysics', 'Chemical Engineering', 'Civil Engineering', 'Mechanical Engineering', 'Astronomy', 'Geological Engineering']``` (these are just some of the most common STEM-related programs related with tech, IT and computer sciences that I am aware of) - uniform distribution
* ```year_level```: Values coming from year level ```[1,2,3,4]``` with the following probability distribution: ```[6%, 21%, 59%, 14%]``` and this is arbitrarily set
* ```email```: A concatenation of first and last names (in lower cases), separated by a ```.``` and then affix a ```@[domain]``` where the ```domain``` could either be one of ```[gmail.com, hotmail.com, msn.com, yahoo.com, outlook.com, abc.edu]``` (the name of the school is University of ABC.
* ```phone_num```: Randomly generated and uses the format ```(XYZ) TUV-PQRS```
* ```gender```: Random with ```M``` for male, ```F``` for female and ```O``` for other (e.g., non-binary, not specified, etc.)
* ```age```: Follows a normal distribution between ```[18, 30]```
* ```cgpa```: Cumulative GPA, also follows a normal distribution

### Assignments and Tests
Displays the student's id's and their raw scores for each assessment.
* ```student_id```: Student ids based on the submitted ids of students in their demographic profile.
* ```raw```: The raw score achieved by the student. ```A1``` is out of ```15```, ```A2``` is out of ```25```, ```A3``` is out of ```20```, ```A4``` is out of ```30```, the ```midterm``` is out of ```45```, and the ```final_exam``` is out of ```100```. For simplicity, all numbers are randomly generated and follows a normal distribution with arbitrary mean and standard deviation values.

## Running the Scripts
Firstly, you want to generate the datasets (you can generate your own if the provided one does not suit your needs). The parameters can also be changed in ```curator.py``` before running the script.
```
python curator.py
```

Once the dataset is generated, load up the MySQL server as follows:
```
/usr/local/mysql/bin/mysql -u root -p --local-infile -s --table
```
where ```-u``` refers to the ```username```, ```-p``` for ```password```, ```--local-infile``` allows for reading files locally, ```-s``` is for silencing messages such as ```Query ok, X rows affected (0.00 sec)```, and ```--table``` allows to display query results pretty-printed as a table. Note that the last flag is important as ```-s``` will disable pretty-printing, so it is important that we combine it with ```--table``` to retain table display while suppressing the unnecessary messages.

Ensure that the database used is set:
```
USE database_name; 
```

Create the tables based on the dataset generated:
```
source schema.sql
```

Then run the query, where ```X``` is the query number:
```
source queries/queryX.sql
```

## Questions and Answers
Here are the sample questions a teacher can ask, query it using SQL, and the corresponding answers. Please find the SQL codes of the following within the ```./queries/``` directory. The query of each is found in ```./queries/qX.sql``` file, where ```X``` is the query number.

Q1. The teacher would like to gain some preliminary statistics about the class demographics. They would like to obtain 5 different tables. The first three would simply be a two-column table where the first one is either ```[program_name, year, gender]``` and the second column is ```count```. The fourth table is the same except that the first column is ```age``` and is instead bracketed using 4 bins. Finally, the fifth table is a 5-column table with columns ```[mean, median, min, max, range]``` that only has 1 row that depicts the statistic for the class ```cgpa```. Sort the results as follows: (T1) by count descending, (T2) by year ascending, (T3) according to ```[M,F,O]```, (T4) by age, (T5) by CGPA. Here are the results:
```
-- T1
+-------------------------+-------+
| program                 | count |
+-------------------------+-------+
| Computer Science        |    17 |
| Computer Engineering    |    17 |
| Astronomy               |    16 |
| Electrical Engineering  |    16 |
| Mechanical Engineering  |    15 |
| Applied Statistics      |    15 |
| Artificial Intelligence |    14 |
| Software Development    |    13 |
| Physics                 |    13 |
| Digital Media           |    13 |
+-------------------------+-------+
10 rows in set (0.00 sec)

-- T2
+------+-------+
| year | count |
+------+-------+
|    1 |    15 |
|    2 |    59 |
|    3 |   138 |
|    4 |    38 |
+------+-------+
4 rows in set (0.00 sec)

-- T3
+--------+-------+
| gender | count |
+--------+-------+
| M      |   113 |
| F      |   112 |
| O      |    25 |
+--------+-------+
3 rows in set (0.00 sec)

-- T4
+---------------+-------+
| age           | count |
+---------------+-------+
| [18,19,20]    |    23 |
| [21,22,23]    |    79 |
| [24,25,26]    |    94 |
| [27,28,29,30] |    54 |
+---------------+-------+
4 rows in set (0.00 sec)

-- T5
+------+--------+------+------+-------+
| mean | median | min  | max  | range |
+------+--------+------+------+-------+
| 7.48 | 7.58   | 5.80 | 8.93 | 3.13  |
+------+--------+------+------+-------+
1 row in set (0.00 sec)
```

Q2. The first assignment has just been marked by the TA. You would like to display the assignment results to the class according to the following schema: ```(student_id, name, a1_score)```, where ```name``` is the concatenation of the student's first and last name separated by a space, ```a1_score``` is the percentage score of the student for ```a1``` (out of 15). To make it more convenient and much easier for students to look up their name, you display the results arranged chronologically by last name. Here is the sample output for the first 10 records:
```
+------------+--------------------+----------+
| student_id | name               | a1_score |
+------------+--------------------+----------+
|  611481869 | Sandra Acosta      | 73.33%   |
|  201254718 | Danielle Alexander | 86.67%   |
|  877197653 | Logan Alexander    | 93.33%   |
|  383230831 | Carol Ali          | 80.00%   |
|  915714920 | Joshua Anderson    | 73.33%   |
|  226303555 | Debra Arroyo       | 86.67%   |
|  750002093 | Andrea Arroyo      | 73.33%   |
|  276936575 | Theresa Atkinson   | 73.33%   |
|  677974469 | Doris Avalos       | 80.00%   |
|  996675949 | Jose Avery         | 86.67%   |
+------------+--------------------+----------+
10 rows in set (0.00 sec)
```
