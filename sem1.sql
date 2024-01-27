CREATE DATABASE workerss;

use workers;

create table worker (
id int primary key not null,
name_worker varchar(30) not null,
dept varchar(30) not null,
salary int
);


INSERT worker (id, name_worker, dept, salary)
VALUES
(100,"AndreyEX","Sales",5000),
(200,"Boris","IT", 5500),
(300,"Anna","IT", 7000),
(400,"Anton","Marketing", 9500),
(500,"Dima","IT", 6000),
(501,"Maxs","Accounting", NULL);

select * from worker;

select * from worker 
where salary > 6000;

select * from worker 
where dept = "It";

select * from worker 
where dept != "It";

select * from worker 
where not dept like "It";

select * from worker 
where dept not like "It";
