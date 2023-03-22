show create table employees;
use hr;
create table emp2 as select employee_id,first_name,last_name,job_id,department_id from employees;
alter table emp2 add column dname varchar(20);

-- Correlated Update
-- update dname column from departments table
update emp2 e set dname=(select department_name from departments d where department_id=e.department_id);

-- Correlated Delete
-- delete rows of emp2 wrt department_id 60 based upon job_id in employees table
start transaction;
delete from emp2 e where job_id in (select job_id from employees where department_id=60 and job_id=e.job_id);
rollback;

commit;
rollback;
delete from emp2 where employee_id=2;

-- Views
-- It is like a vitual table
-- It is used for security purposes
-- Also used for simplyfying query mechanisms

-- create view from emp2 table on people purchasing dept
desc emp2;
create view purchase as select * from emp2 where dname='purchasing';
select * from purchase;

-- Privilage ==> it is a permission to interact with database which can be granted or revoked

-- Data control language
-- create a user
create user 'pur' identified by 'pur';
create user 'pur'@'localhost' identified by 'pur';
-- pur@localhost is user
-- put after identified by is password
create user 'Naga_Prasad'@'localhost' identified by 'Sai@naga';
-- username		=>		Naga_Prasad
-- Password		=>		Sai@naga

-- show the created users in the localhost
select user from mysql.user;

-- creating the user just creates the user with no permissions by deafult
-- the permissions need to be given again in purticular

-- Granting the permission
grant select on hr.purchase to 'pur';
-- Revoke the granted permission
revoke select on hr.purchase from 'pur';
-- grant all permissions on a table for a user
grant all privileges on hr.emp2 to 'Naga_Prasad'@'localhost';
-- see the privilages granted for a user
show grants for 'Naga_Prasad'@'localhost';
-- revoke all the permissions granted to a user on a table
revoke all on hr.emp2 from 'Naga_Prasad'@'localhost';
show grants for 'Naga_Prasad'@'localhost';

-- grant create table to the user
grant create on hr.* to 'Naga_Prasad'@'localhost';
-- revoke create
revoke create on hr.* from 'Naga_Prasad'@'localhost';

-- Privilages available are in this link
-- https://media.geeksforgeeks.org/wp-content/uploads/sqltable.jpg

-- Views
-- Types of views
-- simple 	=> created out of simple table
-- complex 	=> created out of multiple tables
-- 			aggregate function in a view is also a complex view
create view agg_view as select max(salary)'maxsal',job_id from employees where job_id is not null group by job_id; 
select * from agg_view;
-- view using join
create view join_reg_count as select region_name,country_name from regions natural join countries;

select * from join_reg_count;
-- alter on view
alter view join_reg_count as select region_name,country_name from regions natural join countries order by region_name;
start transaction;
delete from join_reg_count;
-- error will be displayed as the tuples in the view if deleted are also deleted from the table it is created from

-- Views with check option
create view view_check as select employee_id,first_name,last_name,salary from employees where employee_id<251 with check option;
desc employees;

-- DMLs on views
-- complex views not posiible
-- aggregate functions,group by,having
-- 
-- 
create view v_sum as select sum(salary) 'total sal',department_id from employees group by departmeny_id;
select * from employees;
select * from v_sum;

create table emp_new as select * from demo.emp;

-- create a file for the entire sql database created
-- in command prompt go to mysql server bin then run the command
-- mysqldump -u root -p (database to be exported)>(file name).sql
-- this exports the database
-- to import this
-- run the following commad
-- mysql -u root -p (database name)<(file name to be imported)

-- Tranaction Control 
-- It mainly contains two commands
-- 1 Commit
-- 2 rollback
-- it works -- Stored procedures on dmls
--   	ACID Properties
-- Atomicity => all transactions should either be commited or roll back
-- Consistency => 
-- Isolation
--       = durability

-- Adhoc Queries
-- As an when required we will create queries
-- if we want repeated activities in databases it is required to create stored onjects to handle such things

-- these are 
-- Stored procedures
-- User Defined Functions
-- Triggers to enforce complex business rules

-- Stored procedures
-- ---------------------------
-- =>Modularity - one procedure after another
-- we need to change the delmiter before and after the creation of trigger
-- procedure,function created we have to change deilimiter

call mypro;
call empout;
call mypro2;
call mypro3('sai');

-- grant user the permission to access procedure
grant execute on procedure hr.mypro3 to 'Naga_Prasad'@'localhost';
select user from mysql.user;