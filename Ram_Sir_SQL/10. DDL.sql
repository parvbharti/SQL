# Data Defination Language
# there are four commands in DDL
#  1.Create
# 2.Alter
# 3.Drop
# 4.Truncate

-- Create table from exixting table
create table newtable as select * from salgrade;
select database();

-- Create a new table
create table oe_tab(
c1 int primary key,
c2 varchar(20) check(c2 in ('odd','even'))
);

-- insert in one column
insert into oe_tab(c1) values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

update oe_tab set c2=if(mod(c1,2)=0,'even','odd');
select * from oe_tab;

-- create table student 1
use hr;
drop table student1;
create table student1(
student_id int primary key,
student_name varchar(15),
result char check(result in ('P','F'))
);
-- copy the tuples prsent in employees table (employee id,name)
insert into student1(student_id,student_name) select employee_id,first_name from employees;
-- update table and set result as p if name contains s else set as f
update student1 set result=if(student_name like "%s%",'P','F');
-- show how many have p and f 
select count(*),result from student1 group by result;

-- create tabel join table by joining employees table and department table
-- with attributes employees_id,firstname,lastname,departmentname
create table join_table as 
select employee_id,first_name,last_name,department_name from employees e 
inner join departments d on e.department_id=d.department_id;

-- Auto Increment
-- Automatically generates sequential numbers during insertion operations
-- only applicable on numeric datatypes
create table ipl_table(
slno int primary key auto_increment,
name varchar(20)
);
insert into ipl_table(name) values ('csk'),('mi'),('gl'),('rcb'),('kkr'),('srh'),('pbks'),('rr');
select * from ipl_table;

