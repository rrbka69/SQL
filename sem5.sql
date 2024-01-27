DROP DATABASE IF EXISTS lesson_5;
CREATE DATABASE lesson_5;
USE lesson_5;

-- Персонал
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
id INT AUTO_INCREMENT PRIMARY KEY,
firstname VARCHAR(45),
lastname VARCHAR(45),
post VARCHAR(100),
seniority INT,
salary INT,
age INT
);

-- Наполнение данными
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 25),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Ольга', 'Васютина', 'Инженер', '2', 70000, 25),
('Петр', 'Некрасов', 'Уборщик', '36', 16000, 59),
('Саша', 'Петров', 'Инженер', '12', 50000, 49),
('Иван', 'Сидоров', 'Рабочий', '40', 50000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49),
('Юрий', 'Онегин', 'Начальник', '8', 100000, 39);


SELECT * FROM staff;

-- Ранжирование : DENSE_RANK RANK NTILE ROW_NUMBER 
-- Выведем список сотрудников с рейтингом по зарплатам 

SELECT 
CONCAT(firstname," ", lastname) AS `name`,
post, salary,
DENSE_RANK() OVER(ORDER BY salary DESC) AS `dense_rank`,
RANK() OVER(ORDER BY salary DESC) AS `rank`,
ROW_NUMBER() OVER(ORDER BY salary DESC) AS `number`,
NTILE(4) OVER(ORDER BY salary DESC) AS `group`
FROM staff;

-- Выведем список сотрудников с рейтингом по зарплатам и сгруппируем по должности 
SELECT 
CONCAT(firstname," ", lastname) AS `name`,
post, salary,
DENSE_RANK() OVER (PARTITION BY post ORDER BY salary DESC) AS `dense_rank`
FROM staff;

-- Получим самых высокооплачиваемых сотрудников по каждой должности 

SELECT post, salary, `name`, `dense_rank`
FROM
(SELECT 
CONCAT(firstname," ", lastname) AS `name`,
post, salary,
DENSE_RANK() OVER (PARTITION BY post ORDER BY salary DESC) AS `dense_rank`
FROM staff) AS rank_list
WHERE `dense_rank` = 1
ORDER BY salary DESC;

-- Вывести сотрудников сгруппиров по должности и вывести:
-- сумму зарплат по должности
-- процентное соотношение одной зарплаты к этой сумме 

SELECT 
id,
CONCAT(firstname," ", lastname) AS `name`,
post, salary,
SUM(salary) OVER w AS "Сумма",
ROUND(salary*100/SUM(salary) OVER w, 3) AS "Процент зарплат",
ROUND(AVG(salary) OVER w,1) AS "Среднее арифметическое",
ROUND(salary*100/AVG(salary) OVER w, 2) AS "Процент зарплат"
FROM staff
WINDOW w AS (PARTITION BY post);

DROP TABLE IF EXISTS academic_record;
CREATE TABLE IF NOT EXISTS academic_record (	student_name varchar(45),
	quartal  varchar(45),
    course varchar(45),
	grade int
);

INSERT INTO academic_record
VALUES	('Александр','1 четверть', 'математика', 4),
	('Александр','2 четверть', 'русский', 4),
	('Александр', '3 четверть','физика', 5),
	('Александр', '4 четверть','история', 4),
	('Антон', '1 четверть','математика', 4),
	('Антон', '2 четверть','русский', 3),
	('Антон', '3 четверть','физика', 5),
	('Антон', '4 четверть','история', 3),
    ('Петя', '1 четверть', 'физика', 4),
	('Петя', '2 четверть', 'физика', 3),
	('Петя', '3 четверть', 'физика', 4),
	('Петя', '4 четверть', 'физика', 5);

SELECT * 
FROM academic_record;

-- Получить с помощью оконных функции:
-- 1. Средний балл ученика
-- 2. Наименьшую оценку ученика
-- 3. Наибольшую оценку ученика
-- 4. Выведите всех учеников без повторений

SELECT DISTINCT student_name,
AVG(grade) OVER w AS "Средний балл",
MIN(grade) OVER w AS "MIN",
MAX(grade) OVER w AS "MAX"
FROM academic_record
WINDOW w AS (PARTITION BY student_name);

-- Функции смещения LAG LEAD FIRST_VALUE LAST_VALUE
SELECT 
CONCAT(firstname," ", lastname) AS `name`,
post, salary, id,
LAG(id) OVER w AS `lag`,
LEAD(id) OVER w AS `lead`,
FIRST_VALUE(`firstname`) OVER w AS `first`,
LAST_VALUE(id) OVER w AS `last`
FROM staff
WINDOW w AS (PARTITION BY post);

CREATE VIEW v1 AS
SELECT 
CONCAT(firstname," ", lastname) AS `name`,
post, salary, id,
LAG(id) OVER w AS `lag`,
LEAD(id) OVER w AS `lead`,
FIRST_VALUE(`firstname`) OVER w AS `first`,
LAST_VALUE(id) OVER w AS `last`
FROM staff
WINDOW w AS (PARTITION BY post);

SELECT * FROM v1;

ALTER VIEW v1 AS
SELECT 
CONCAT(firstname," ", lastname) AS `name`,
post, salary, id,
LAG(id) OVER w AS `lag`,
LEAD(id) OVER w AS `lead`,
FIRST_VALUE(`firstname`) OVER w AS `first`,
LAST_VALUE(id) OVER w AS `last`
FROM staff
WINDOW w AS (PARTITION BY post);

CREATE OR REPLACE VIEW v2 AS
SELECT 
CONCAT(firstname," ", lastname) AS `name`,
post, salary, age,
DENSE_RANK() OVER(ORDER BY salary DESC) AS `dense_rank`,
RANK() OVER(ORDER BY salary DESC) AS `rank`,
ROW_NUMBER() OVER(ORDER BY salary DESC) AS `number`,
NTILE(4) OVER(ORDER BY salary DESC) AS `group`
FROM staff;

SELECT * FROM v2
WHERE salary > 50000;


DROP TABLE IF EXISTS summer_medals;
CREATE TABLE IF NOT EXISTS summer_medals 
(
	year INT,
    city VARCHAR(45),
    sport VARCHAR(45),
    discipline VARCHAR(45),
    athlete VARCHAR(45),
    country VARCHAR(45),
    gender VARCHAR(45),
    event VARCHAR(45),
    medal VARCHAR(45)
);


INSERT summer_medals
VALUES
	(1896, "Athens", "Aquatics", "Swimming", "HAJOS ALfred", "HUN", "Men","100M Freestyle", "Gold"),
	(1896, "Athens", "Archery", "Swimming", "HERSCHMANN Otto", "AUT", "Men","100M Freestyle", "Silver"),
    (1896, "Athens", "Athletics", "Swimming", "DRIVAC Dimitros", "GRE", "Men","100M Freestyle For Saliors", "Bronze"),
    (1900, "Athens", "Badminton", "Swimming", "MALOKINIS Ioannis", "GRE", "Men","100M Freestyle For Saliors", "Gold"),
    (1896, "Athens", "Aquatics", "Swimming", "CHASAPIS Spiridon", "GRE", "Men","100M Freestyle For Saliors", "Silver"),
    (1896, "Athens", "Aquatics", "Swimming", "CHOROPHAS Elfstathios", "GRE", "Men","1200M Freestele", "Bronze"),
    (1905, "Athens", "Aquatics", "Swimming", "HAJOS ALfred", "HUN", "Men","100M Freestyle For Saliors", "Gold"),
    (1896, "Athens", "Aquatics", "Swimming", "ANDREOU Joannis", "GRE", "Men","1200M Freestyle", "Silver"),
    (1896, "Athens", "Aquatics", "Swimming", "CHOROPHAS Elfstathios", "GRE", "Men","400M Freestyle", "Bronze");


/*1.	Выберите имеющиеся виды спорта и пронумеруем их в алфавитном порядке
2.	Создайте представление, в которое попадает информация о спортсменах (страна, пол, имя)
3.Создайте представление, в котором будет храниться информация о спортсменах по конкретному виду спорта (Aquatics)*/


SELECT * FROM summer_medals;

SELECT sport,
ROW_NUMBER() OVER(ORDER BY sport) AS `number`
FROM 
(SELECT DISTINCT sport FROM summer_medals) AS sports;

CREATE VIEW v3 AS 
SELECT athlete, country, gender
FROM summer_medals;

SELECT * FROM v3;

SELECT * FROM v4;

ALTER VIEW v4 AS 
SELECT athlete, country, gender, sport
FROM summer_medals
WHERE sport = "Aquatics";