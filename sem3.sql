DROP DATABASE IF EXISTS `lesson3`;
CREATE DATABASE IF NOT EXISTS `lesson3`;
USE `lesson3`;

DROP TABLE IF EXISTS `staff`;
CREATE TABLE IF NOT EXISTS `staff`
(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`firstname` VARCHAR(45),
`lastname` VARCHAR(45),
`post` VARCHAR(45),
`seniority` INT,
`salary` INT,
`age` INT
);

INSERT INTO `staff` (`firstname`, `lastname`, `post`,`seniority`,`salary`, `age`)
VALUES
('Вася', 'Васькин', 'Начальник', 40, 100000, 60), 
('Петр', 'Власов', 'Начальник', 8, 70000, 30),
('Катя', 'Катина', 'Инженер', 2, 70000, 25),
('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
('Иван', 'Петров', 'Рабочий', 40, 30000, 59),
('Петр', 'Петров', 'Рабочий', 20, 55000, 60),
('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
('Максим', 'Петров', 'Рабочий', 2, 11000, 19),
('Юрий', 'Петров', 'Рабочий', 3, 12000, 24),
('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);

DROP TABLE IF EXISTS activity_staff;
CREATE TABLE IF NOT EXISTS activity_staff
(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`staff_id` INT,
FOREIGN KEY(staff_id) REFERENCES staff(id),
`date_activity`DATE,
`count_pages` INT
);

INSERT activity_staff (`staff_id`, `date_activity`, `count_pages`)
VALUES
(1,'2022-01-01',250),
(2,'2022-01-01',220),
(3,'2022-01-01',170),
(1,'2022-01-02',100),
(2,'2022-01-01',220),
(3,'2022-01-01',300),
(7,'2022-01-01',350),
(1,'2022-01-03',168),
(2,'2022-01-03',62),
(3,'2022-01-03',84);

-- Посчитаем среднюю зарплату по фирме 
SELECT AVG(salary)
FROM staff;

SELECT * FROM staff
WHERE salary > AVG(salary); -- неверная запись

SELECT * FROM staff
WHERE salary > 38500;

SELECT * FROM staff
WHERE salary > (SELECT AVG(salary)
FROM staff);

-- Отсортируем сотрудников по зарплате по возрастанию 
SELECT *
FROM staff
ORDER BY salary; -- ASC - от меньшего к большему 

-- Отсортируем сотрудников по зарплате по убыванию 
SELECT *
FROM staff
ORDER BY salary DESC ; -- DESC - от меньшему к большему 

-- Отсортируем сотрудников по зарплате по возрастанию, только тех у кого стаж больше 5 лет и должность "Рабочий" 
SELECT *
FROM staff
WHERE seniority > 5 AND post = "Рабочий"
ORDER BY salary; 

SELECT * 
FROM staff
ORDER BY age;

-- Отсортируем сначала по имени, потом по возрасту по убыванию 

SELECT * 
FROM staff
ORDER BY firstname DESC, age DESC;


SELECT * 
FROM staff
ORDER BY firstname, age DESC;


-- Подсчитаем колво сотрудников 
SELECT COUNT(lastname)
FROM staff;

SELECT id, lastname
FROM staff
ORDER BY lastname;

SELECT COUNT( DISTINCT lastname)
FROM staff;

SELECT DISTINCT lastname
FROM staff
ORDER BY lastname;

SELECT COUNT(lastname) - COUNT( DISTINCT lastname) AS result
FROM staff;

-- Выведем первые 5 строк 
SELECT age, lastname 
FROM staff
LIMIT 5;

-- Выведем 6 строк с третьей строки 

SELECT id, age, lastname 
FROM staff
LIMIT 2, 6; -- первая цифра - колво пропущенных строк. вторая цифра - колво выведенных строк

SELECT id, age, lastname 
FROM staff
ORDER BY id DESC
LIMIT 2, 6;

-- Сгруппирруем наших работников по должности, выведем макс и мин зарплаты
SELECT GROUP_CONCAT(lastname), SUM(salary), post,
COUNT(lastname),
MAX(salary) AS "Максимальная зарплата",
MIN(salary) AS "Минимальная зарплата"
FROM staff
GROUP BY post;

SELECT lastname, salary, post,
COUNT(lastname),
MAX(salary) AS "Максимальная зарплата",
MIN(salary) AS "Минимальная зарплата"
FROM staff
GROUP BY post;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


SELECT * FROM activity_staff;

-- Выведем общее колво страниц напечатанных каждым сотрудником 
SELECT SUM(count_pages), staff_id
FROM activity_staff
GROUP BY staff_id;

SELECT SUM(count_pages), date_activity
FROM activity_staff
GROUP BY date_activity;

SELECT AVG(count_pages), date_activity
FROM activity_staff
GROUP BY date_activity;

/*Сгруппируйте данные о сотрудниках по возрасту: 
1 группа – младше 20 лет
2 группа – от 20 до 40 лет
3 группа – старше  40 лет 
Для каждой группы  найдите суммарную зарплату
*/

SELECT SUM(salary), name_age
FROM
(SELECT salary,
	CASE 
		WHEN age < 20 THEN "Младше 20 лет"
        WHEN age between 20 AND 40 THEN "от 20 до 40 лет"
        WHEN age > 40 THEN "старше  40 лет "
        ELSE "Не определено"
	END AS name_age
FROM staff) AS lists
GROUP BY name_age;


SELECT GROUP_CONCAT(lastname), salary
FROM staff
GROUP BY salary
WHERE salary > 50000;

SELECT GROUP_CONCAT(lastname), salary
FROM staff
GROUP BY salary
HAVING salary > 50000;

SELECT salary
FROM staff
WHERE salary > 50000;

SELECT salary
FROM staff
HAVING salary > 50000;

SELECT SUM(salary), post
FROM staff
WHERE post != "Начальник"
GROUP BY post
HAVING SUM(salary) > 50000;

SELECT * FROM staff
WHERE salary > (SELECT AVG(salary)
FROM staff);


/*
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
*/