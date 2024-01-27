DROP DATABASE IF EXISTS lesson6;
CREATE DATABASE IF NOT EXISTS lesson6;
USE lesson6;

-- Процедуры
DROP PROCEDURE proc1;
DELIMITER //
CREATE PROCEDURE proc1()
BEGIN 
	CASE
		WHEN CURTIME() BETWEEN '06:00:00' AND '11:59:59' THEN
			SELECT 'Доброе утро' AS `time`;
		WHEN CURTIME() BETWEEN '12:00:00' AND '17:59:59' THEN
			SELECT 'Добрый день';
		WHEN CURTIME() BETWEEN '18:00:00' AND '23:59:59' THEN
			SELECT 'Добрый вечер';
		ELSE 
			SELECT 'Доброй ночи';
	END CASE;
END //
DELIMITER ;


CALL proc1();


--Функции

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

DELIMITER //
CREATE PROCEDURE proc2(num INT)
BEGIN
	SELECT * FROM staff WHERE num = id;
END //
DELIMITER ;

CALL proc2(2);

DELIMITER //
CREATE FUNCTION fibonacci(num INT) -- колво чисел Фибоначчи для вывода 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	DECLARE fib1 INT DEFAULT 0;
    DECLARE fib2 INT DEFAULT 1;
    DECLARE fib3 INT DEFAULT 0;
    DECLARE result  VARCHAR(50) DEFAULT "0 1"; -- Первые 2 числа Фибоначчи 
    IF num = 1 THEN
		RETURN fib1;
    ELSEIF num = 2  THEN
		RETURN CONCAT(fib1," ", fib2); -- = result 
    ELSE 
		WHILE num > 2 DO
			SET fib3 = fib1 + fib2;
            SET fib1 = fib2;
            SET fib2 = fib3;
            SET num = num - 1;
            SET result = CONCAT(result, " ", fib3);
		END WHILE;
        RETURN result;
	END IF;
    END //
    DELIMITER ;
    
SELECT fibonacci(11);


/* Создайте и вызовите процедуру, которая будет выводить: 
 Однозначное число - если параметр от 1 до 9
 Двухзначное число - от 10 до 99 
 Трехзначное число - от 100 до 999
 */
 DROP PROCEDURE proc3;
 DELIMITER //
 CREATE PROCEDURE proc3(num INT) 
 BEGIN
	CASE 
		WHEN num BETWEEN 1 AND 9 THEN 
			SELECT num, "Однозначное" AS message;
		WHEN num BETWEEN 10 AND 99 THEN 
			SELECT num, "Двухзначное" AS message;
        WHEN num BETWEEN 100 AND 999 THEN 
			SELECT num, "Трехзначное" AS message;    
		ELSE 
			SELECT num, "Некорректное число" AS message;
		END CASE; 
 END //
 DELIMITER ;
 
 CALL proc3(3333);
 
 /* Создайте функцию, которая будет вычислять сумму трех переменных: а = 2030, b = 5125, c = 7903 */
  DELIMITER //
 CREATE FUNCTION sum3() 
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE num1 INT DEFAULT 2030;
    DECLARE num2 INT DEFAULT 5124;
    DECLARE num3 INT DEFAULT 7903;
    DECLARE result INT; 
    SET result = num1+num2+num3;
    RETURN result;
END //
DELIMITER ;
 
 SELECT sum3();
 
 
   DELIMITER //
 CREATE FUNCTION sum3_1(a INT, b INT, c INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE result INT; 
    SET result = a+b+c;
    RETURN result;
END //
DELIMITER ;
 
 SELECT sum3_1(2,3,4);
 
 
CREATE TABLE bankaccounts(accountno varchar(20) PRIMARY KEY NOT NULL, funds decimal(8,2));
INSERT INTO bankaccounts VALUES("ACC1", 1000);
INSERT INTO bankaccounts VALUES("ACC2", 1000);

SELECT * FROM bankaccounts;

START TRANSACTION;
UPDATE bankaccounts
SET funds = funds - 100 WHERE accountno = "ACC1";
UPDATE bankaccounts
SET funds = funds + 100 WHERE accountno = "ACC2";
ROLLBACK;


START TRANSACTION;
UPDATE bankaccounts
SET funds = funds - 100 WHERE accountno = "ACC1";
UPDATE bankaccounts
SET funds = funds + 100 WHERE accountno = "ACC2";
COMMIT;



START TRANSACTION;
UPDATE bankaccounts
SET funds = funds - 100 WHERE accountno = "ACC1";
UPDATE bankaccounts
SET funds = funds + 100 WHERE accountno = "ACC2";
TRUNCATE bankaccounts;
