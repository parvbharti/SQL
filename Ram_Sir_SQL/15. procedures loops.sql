-- to check available procedures 
select * from information_schema.routines;
select specific_name,routine_type from information_schema.routines where routine_schema='hr';
use hr;
show create procedure mypro;

delimiter $
create procedure pro_5()
begin
select * from job_grades;
end $
delimiter ;
call pro_5();

-- create a procedure that takes two parameters as input and display their product
delimiter $
create procedure pro_4(x int,y int)
begin
select x*y as 'product';
end $
delimiter ;
call pro_4(10,20);

-- create procedure to pass department_id as parameter and
-- display first_name,lastname,salary,job_id from employees of that department id
delimiter $
create procedure details(id int)
begin
select first_name,last_name,salary,job_id from employees where department_id=id;
end $
delimiter ;

call details(70);

-- create prcedure to pass job_id as parameter and print max(sal) and total salary for that job_id
delimiter $
create procedure job_id_salary(id int)
begin
select max(salary),sum(salary) from employees where job_id=id;
end $
delimiter ;
call job_id_salary('ad_vp');

-- create a procedure to print region name and country name when region_id parameter is passed
show tables;

delimiter $
create procedure region_counteries(id int)
begin
select region_name,country_name from regions natural join countries where region_id=id;
end $
delimiter ;

call region_counteries(1);

-- create procedure to take id and name as parameter and insert those values into 
delimiter $
create procedure insert_regions(regid int,regname varchar(20))
begin
insert into regions values(regid,regname);
end $
delimiter ;

call insert_regions(5,'pandipur');
select * from regions;

-- create procedure to update the row from regions table by passing region_id
delimiter $
create procedure update_regions(regid int,name varchar(20))
begin
update regions set region_name=name where region_id=regid;
end $
delimiter ;
call update_regions(5,'kondapur');

-- create procedure to delete the row from regions table by passing region_id
delimiter $
create procedure delete_regions(regid int)
begin
delete from regions where region_id=regid;
end $
delimiter ;
call delete_regions(5);

-- If,If-else,If-elseif-else
-- if=>
-- 		if<condi> then
-- 			statements;
-- 		end if
-- if-else=>
-- 		if<condi> then
-- 			statements
-- 		else
-- 			statements
-- 		end if
-- if-elseif-else=>
-- 		if<condi> then
-- 			statements
-- 		elseif <condi> then
-- 			statements
-- 		else
-- 			statements
-- 		end if

-- create procedure to pass age as parameter and display minor,major,senoir as output
delimiter $
create procedure age(n int)
begin
declare type varchar(10);
if(n<18) then 
set type='minor';
elseif(n<60) then
set type='major';
else
set type='senior';
end if;
select type;
end $
delimiter ;

call age(89);


-- create a procedure to pass string as parameter and print as upper if lower and viceversa and if mixed case print
-- 'enter only in lower or upper'
delimiter $
create procedure str_type(str varchar(30))
begin
if(binary str=binary lower(str)) then 
select 'lower' type,upper(str);
elseif(binary str=binary upper(str)) then
select 'upper' type,lower(str);
else
select 'enter only lower or upper';
end if;
end $
delimiter ;

call str_type('sai');

-- take two employee id as input and compare their salaries
delimiter $
create procedure compare_sal(p1 int,p2 int)
begin
declare v1 int;
declare v2 int;
select salary into v1 from employees where employee_id=p1;
select salary into v2 from employees where employee_id=p2;
if(v1=v2) then 
select 'salaries are equal' compare;
elseif(v1<v2) then
select 'salaries of employee1 is more' compare;
else
select 'salaries of employee2 is more' compare;
end if;
end $
delimiter ;
call compare_sal(100,101);

-- create a procedure to take employee_id as parameter and 
-- print if he is taking min salary in job_id
-- print if he is taking max salary in job_id
-- print if he is taking neither of these
delimiter $
create procedure emp_sal(p1 int)
begin
declare v1 int;
declare v2 numeric(11,2);
declare v3 numeric(11,2);
select salary into v1 from employees where employee_id=p1;
select min(salary),max(salary) into v2,v3 from employees where job_id=(select job_id from employees where employee_id=p1);
if(v1=v2) then 
select 'salary is minimum' compare;
elseif(v1=v3) then
select 'salary is maximum' compare;
else
select 'salary is neither minimum noe maximum' compare;
end if;
end $
delimiter ;
call emp_sal(100);

-- Loops
-- While Loop
-- this does the activity as long as the condition is true
-- delimiter $
-- create procedure name
-- begin
-- declare...
-- while condition do
-- statments;
-- end while

create table while_tab(slno int primary key);
-- create a procedure to insert 100 rows into the while_tab table
delimiter $
create procedure insertrows()
begin
declare v int;
set v=1;
while(v<101) do
insert into while_tab values (v);
set v=v+1;
end while;
end $
delimiter ;

call insertrows();
select * from while_tab;

use demo;
show tables;
select * from oe_tab;
delete from oe_tab;
-- add 1000 values to oe_tab with all columns
delimiter $
create procedure or_tab_insert()
begin
declare v1 int;
declare v2 varchar(20);
set v1=1;
while(v1<1001) do
if(v1%2=0) then
set v2='even';
else
set v2='odd';
end if;
insert into oe_tab values (v1,v2);
set v1=v1+1;
end while;
end $
delimiter ;
call or_tab_insert();
select * from oe_tab;

-- create a table which containsall your birthdays daynames till today from born
create table days(date1 date,dayname varchar(20));
delimiter $
create procedure daysinsert()
begin
declare v1 date;
declare v2 varchar(20);
set v1='2001-05-18';
while(v1<curdate()) do
set v2=dayname(v1);
insert into days values(v1,v2);
set v1=date_add(v1,interval '1' year);
end while;
end $
delimiter ;
call daysinsert();
select * from days;

-- show all the second saturdays of every month in each month of 2022
create table secondsat(month1 varchar(20),date1 date);
delimiter $
create procedure secondsat()
begin
declare v1 date;
set v1='2022-01-01';
while(v1<'2023-01-01')do
if(dayname(v1)='saturday') then
set v1=date_add(v1,interval '7' day);
insert into secondsat values(monthname(v1),v1);
set v1=date_add(last_day(v1),interval '1' day);
else
set v1=date_add(v1,interval '1' day);
end if;
end while;
end $
delimiter ;
call secondsat();
select * from secondsat;

-- Simple loop
-- it is just like do-while loop
-- example
create table table1(c1 int);
delimiter $
create procedure simpleloop()
begin
declare v1 int default 1;
simple_loop:loop
insert into table1 values(v1);
set v1=v1+1;
if v1=51 then 
leave simple_loop;
end if;
end loop simple_loop;
end $
delimiter ;
call simpleloop();
select * from table1;
delete from table1;
delimiter $
create procedure simpleloop1()
begin
declare v1 int default 1;
loops:loop
insert into table1 values(v1);
set v1=v1+1;
if v1=51 then 
leave loops;
end if;
end loop loops;
end $
delimiter ;
call simpleloop1();
select * from table1;


-- Triggers
-- It is like a databse object that automatically initiates when an event is triggered
-- the event may be any of 
-- 1.insert  => new
-- 2.update  => new/old
-- 3.delete  => old

-- example
create table retired as select first_name from emp1 where 1=2;
-- create a trigger to insert retired tuple name from emp1 to retired table
delimiter $
create trigger trig1
before delete on emp1
for each row
begin
insert into retired values(old.first_name);
end $
delimiter ;
start transaction;
delete from emp1 where employee_id=100;
select * from retired;
rollback;

-- create a triggger on insert to convert name to upper case if lower case name is entered
delimiter $
create trigger insert1
before insert on retired
for each row
begin
set new.first_name=upper(first_name);
end $
delimiter ;


insert into retired values('sai');
select * from retired;

create table account(accno numeric(10) primary key,name varchar(20),balanace numeric(11,2));
create table trans(accno numeric(10),wd numeric(11,2),dep numeric(11,2),foreign key(accno) references account(accno));
insert into retired select first_name from emp1;
show tables;v