DROP DATABASE IF EXISTS lesson4;
CREATE DATABASE IF NOT EXISTS lesson4;
USE lesson4;

DROP TABLE IF EXISTS teacher;
CREATE TABLE IF NOT EXISTS teacher
(	
	id INT NOT NULL PRIMARY KEY,
    surname VARCHAR(45),
    salary INT
);

INSERT teacher
VALUES
	(1,"Авдеев", 17000),
    (2,"Гущенко",27000),
    (3,"Пчелкин",32000),
    (4,"Питошин",15000),
    (5,"Вебов",45000),
    (6,"Шарпов",30000),
    (7,"Шарпов",40000),
    (8,"Питошин",30000);
    
SELECT * from teacher; 

DROP TABLE IF EXISTS lesson;
CREATE TABLE IF NOT EXISTS lesson
(	
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    course VARCHAR(45),
    teacher_id INT,
    FOREIGN KEY (teacher_id)  REFERENCES teacher(id)
);
INSERT INTO lesson(course,teacher_id)
VALUES
	("Знакомство с веб-технологиями",1),
    ("Знакомство с веб-технологиями",2),
    ("Знакомство с языками программирования",3),
    ("Базы данных и SQL",4);

SELECT * FROM teacher; 
SELECT * FROM lesson; 

-- Получим информацию о преподвателях, которые ведут курсы 

SELECT * FROM teacher, lesson
WHERE teacher.id = lesson.teacher_id;

SELECT teacher.surname, lesson.course 
FROM teacher 
JOIN lesson -- INNER JOIN = JOIN 
ON teacher.id = lesson.teacher_id;

-- Получим всех преподавателей 
SELECT t.surname, l.course, t.id, l.teacher_id
FROM teacher AS t
LEFT JOIN lesson AS l
ON t.id = l.teacher_id;


SELECT t.surname, l.course, t.id, l.teacher_id
FROM lesson AS l
RIGHT JOIN  teacher AS t
ON t.id = l.teacher_id;

-- Получим фамилии преподавателей, которые ничего не ведут

SELECT t.surname, l.course, t.id, l.teacher_id
FROM teacher AS t
LEFT JOIN lesson AS l
ON t.id = l.teacher_id
WHERE l.course IS NULL;


SELECT web_teacher.*, l.*
FROM lesson AS l 
RIGHT JOIN
(SELECT id, surname FROM teacher 
WHERE surname = "Питошин") AS web_teacher
ON web_teacher.id = l.teacher_id;

SELECT * FROM teacher 
WHERE id IN (1,3);

-- Получим информацию о преподвателях, которые ведут курсы 
SELECT * FROM teacher 
WHERE EXISTS 
(SELECT * FROM lesson 
WHERE teacher.id = lesson.teacher_id);

SELECT * FROM teacher 
WHERE NOT EXISTS 
(SELECT * FROM lesson 
WHERE teacher.id = lesson.teacher_id);

-- Получим информацию по преподавателям, которые ведут Знакомство с веб тех 

SELECT *
FROM teacher AS t
JOIN lesson AS l
ON t.id = l.teacher_id
WHERE l.course ="Знакомство с веб-технологиями";

SELECT *
FROM teacher AS t
JOIN 
(SELECT * FROM lesson 
WHERE course ="Знакомство с веб-технологиями") AS web_lesson
ON t.id = web_lesson.teacher_id;

SELECT * FROM teacher
WHERE EXISTS (SELECT * FROM lesson WHERE teacher.id = lesson.teacher_id AND course ="Знакомство с веб-технологиями");


SELECT *
FROM teacher
CROSS JOIN lesson;

SELECT * FROM teacher
UNION
SELECT * FROM lesson;

SELECT id FROM teacher
UNION
SELECT id FROM lesson;

SELECT id FROM teacher
UNION ALL
SELECT id FROM lesson;

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id  int auto_increment primary key,
    login varchar(255) null,
    pass  varchar(255) null,
    male  tinyint      null
);

DROP TABLE IF EXISTS clients;
CREATE TABLE IF NOT EXISTS clients
(
    id    int auto_increment primary key,
    login varchar(255) null,
    pass  varchar(255) null,
    male  tinyint      null
);

INSERT INTO users (login, pass, male) 
VALUES 
('alex', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1),
('Mikle', '$ws$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1),
 ('Olia', '$2y$10$88zbBCKLJklStIgTqBKIluijJUnbeZ5WqJI4RJgkksnFZon5kH14y', 2),
 ('Tom', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH20y', 1),
('Margaret', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ4wqIu4RJgkksnFZon5kH20y', 2);

INSERT INTO clients (login, pass, male) VALUES ('alexander', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1),
 ('Mikle', '$ws$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1),
('Olia', '$2y$10$88zbBCKLJklStIgTqBKIluijJUnbeZ5WqJI4RJgkksnFZon5kH14y', 2),
('Dmitry', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH20y', 1),
 ('Margaret', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ4wqIu4RJgkksnFZon5kH20y', 2),
('Leonid', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1),
 ('Olga', '$2y$10$88zbBCKLJklStIgTqBKIluijJUnbeZ5WqJI4RJgkksnFZon5kH14y', 2),
 ('Tom', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH20y', 1),
('Masha', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ4wqIu4RJgkksnFZon5kH20y', 2),
 ('alex', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);
