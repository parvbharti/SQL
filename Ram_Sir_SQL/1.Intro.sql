-- It is a rdbms
-- founders
--  -david axmark
--  -allan larson
--  -michel monty
-- previously called as my Ess Que Ell

-- connecting to mysql
-- -online compiler(paisa)
-- -command line interface
-- -cmd (mysql -u root -p)
-- -workbench

-- commands
-- see databases that are present in the system {show databases}
show databases;
-- to know current database {select database()}
select database();
-- to create database {create database name}
create database demo;
-- to use a database {use name_of_database}
use demo;
-- to see tables in a database {show tables}
show tables;
-- to see columns from a table {show columns from table_name}
show columns from emp;
desc dept;
select * from information_schema.columns where table_name='dept';
-- types of sql commands
-- -select
-- -DDL
-- -DML
-- -DCL
-- -TCL
-- to see tows {select * from table_name}
select * from dept;
select * from emp;
select * from salgrade;

-- RDBMS was based on relational algebra and relational calculus operators
-- it was further classified into set oriented and relational oriented

-- Set Oriented
-- -Union
-- -Intersection
-- -Minus
-- -Product

-- Relational Oriented
-- -Projection
-- -Restriction
-- -Join
 
 -- Projection 
 -- -show selected no of coloumns
 -- -explicitely mention column name
 select dname from dept;
 -- -* refers to all
 -- -select multiple columns using comma seperator
 select dname,loc from dept;

-- Restriction
-- ->also called selection
-- ->Specific rows can be selected
-- ->where clause
select * from dept where deptno=10;

-- hierarchy of mysql
-- * select
-- * from
-- * where
-- * group by
-- * having
-- * order by

-- Data is case sensitive in oracle but not in mysql

-- Operators that can be used with where clause
-- 1)Comparision  => <,>,>=,<=,<>,!=
-- <>,!=  are not equal to
-- 2)Logical  => and,or,not
-- 3) Special => in,not in,between 
-- 4)Pattern => like,not like 
-- 5)Null => is null, is not null

CREATE TABLE SALGRADE
      ( GRADE int,
	LOSAL int,
	HISAL int );
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);


CREATE TABLE DEPT
       (DEPTNO INT(2) PRIMARY KEY,
	DNAME VARCHAR(14) ,
	LOC VARCHAR(13) ) ;


INSERT INTO DEPT VALUES
	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES
	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES
	(40,'OPERATIONS','BOSTON');


CREATE TABLE EMP
       (EMPNO int(4) PRIMARY KEY,
	ENAME varchar(10),
	JOB varchar(9),
	MGR int(4),
	HIREDATE DATE,
	SAL float(7),
	COMM float(7),
	DEPTNO int(2), CONSTRAINT FK_DEPTNO foreign key(deptno) REFERENCES DEPT(deptno));

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,'1981-2-20',1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,'1981-2-22',1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,'1981-4-2',2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,'1981-9-28',1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,'1981-5-1',2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,'1981-6-9',2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,'1987-07-13',3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,'1981-9-8',1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,'1987-07-13',1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,'1981-12-3',950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,'1981-12-3',3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,'1982-1-23',1300,NULL,10);

-- Operators that can be used with where clause
-- 1)Comparision  => <,>,>=,<=,<>,!=
-- <>,!=  are not equal to
-- 2)Logical  => and,or,not
-- 3)Special => in,not in,between 
-- 4)Pattern => like,not like 
-- 5)Null => is null, is not null

-- find all employees working as salesman
select * from emp where job='salesman';
-- find employees who joined on 1981-12-03
select * from emp where hiredate='1981-12-03';
-- find employees who have joined after 1981-12-03
select * from emp where hiredate>'1981-12-03';
-- find employees who are takoing salaries more or equal to 2975
select * from emp where sal>=2975;
-- find employees who are takoing salaries less than or equal to 1250
select * from emp where sal<=1250;
-- find employees who are not managers
select * from emp where job <> 'manager';
select * from emp where job != 'manager';
-- using not operator
select * from emp where not (job='manager');
-- find out employees working in dept no 20 as clerk
select * from emp where job='clerk' and deptno=20;
-- find out employees working in dept no 30 and taking salary 3000
select * from emp where sal=3000 or deptno=30;

-- Logical Operator 
-- 1)and
-- 2)or
-- 3)not
 
-- find employees who are taking salaries not less than 3000 dont use >
select * from emp where not(sal<3000);

-- Special Operators
-- 1)In
-- 2)Not in
-- 3)Betwwen
-- here multiple values can be provided

-- find employees with dept id 10 and 30
select * from emp where deptno=10 or deptno=30;
-- using in operator
select * from emp where deptno in (10,30);
-- find employees with not dept id 10 and 30
select * from emp where deptno not in (10,30);
-- display details for empno 7566,7521,7839,7902
select * from emp where empno in (7566,7521,7839,7902);

-- Between
-- 1)range operator
-- 2)uses and operator together
-- 3)lower limit first
-- 4)upper limit second
-- 5)works like >=lowerlimit and <=higherlimit

-- display all employees with salary range of 1500 to 3000
select * from emp where sal between 1500 and 3000;
-- find enames between james and turner
select * from emp where ename between 'james' and 'turner';
-- find employees joined between 1980-12-17 and 1981-02-22
select * from emp where hiredate between '1980-12-17' and '1981-02-22';

-- Pattern Matching 
-- 1)Like
-- 2)Not like
-- here % refers to pattern              Ex: names starting or ending with a purticular character "%c" or "c%"
--      _ refers to single character     Ex: names having four letters "____"

-- find ename starting with j
select ename from emp where ename like "j%";
-- find ename ending with n
select ename from emp where ename like "%n";
-- find ename starting with a and ending with s
select ename from emp where ename like "a%" and ename like '%s';
-- find ename with t anywhere
select ename from emp where ename like "%t%";
-- find ename where 3rd character is r;
select ename from emp where ename like "__r%";
-- find employees joined in februvary
select * from emp where hiredate like "_____02___";

-- if the name has _ in the string hoe to get those is given below
use demo;
start transaction;
update emp set job='sales_rep' where job='salesman';
select * from emp where job like '%\_%';
rollback;

select * from emp;
commit;

-- find employees not joined in 1981
select * from emp where hiredate not like '1981%';

-- if columns are having null values they can be selected using is keyword
-- there are 12 rules of codd
-- 1) data should be stored in form of tables only
-- 2) 
-- 3) database should not support systematic treatment of nulls
-- 4)
-- 8) physical data independence rule
-- 9) logiacal data independency rule

-- find ename where comm is null
select ename,comm from emp where comm is null;
-- find ename where comm is not null
select ename,comm from emp where comm is not null;

-- DDL(Data Defination Language)
-- This contains 1)Create 2)Alter 3)Drop 4)Truncate

-- CREATE 
-- $ It is used to create new database objects
-- $ create table from existing table with or without rows
-- $ CTA's known as create table as

create table dept1 as select * from dept; -- rows are copied here
show tables;
create table dept2 as select * from dept where 1=2; -- rows are not copied here

-- create a table
create table birthtable(name varchar(20),
						dob date);
                        
-- DML(Data Manipulation Language)
-- this contains commands like 1)insert 2)update 3)delete
-- insert => fresh rows
-- update => modifying existing rows
-- delete => removing existing rows

-- ways of insert statement
-- default order
insert into birthtable values ('sai','2001-05-18');
-- changed order
insert into birthtable(dob,name) values ('1901-09-08','rupesh');
-- multiple rows at a time
insert into birthtable values ('sai','2001-05-18'),('sravan','1254-09-25');
-- using set options
set @v1='ricky';
set @v2='1987-09-08';
insert into birthtable values(@v1,@v2);
-- copying rows
insert into birthtable select ename,hiredate from emp;
-- inserting nulls
-- this can be acheived by following the below methods
-- omit the column
insert into birthtable(name) values ('rakesh');
-- explicitely using null key word without quotes
insert into birthtable(dob,name) values (null,null);
select * from birthtable;
-- find out employees who are having five characters in their ename
select ename from emp where ename like '_____';
-- update
-- modify dob for null values
select * from birthtable;
update birthtable set dob=current_date where name='rakesh';
-- delete
-- removes the rows
-- remove rows from table where the name is rakesh
delete from birthtable where name='rakesh';
-- remove all rows having n in the name
delete from birthtable where name like '%n%';