-- Ques 1
-- create table
create table auto1(player_id int primary key auto_increment,player_name varchar(20));
-- insert values
insert into auto1(player_name) values('virat'),('rohit'),('rahul'),('bumrah');
-- find out last auto_increment
select last_insert_id();
-- change autoincrement to 2000
alter table auto1 auto_increment=2000;
-- insert values
insert into auto1(player_name) values('iyer'),('pant'),('axar');
-- write the output
select * from auto1;
#1	virat
#2	rohit
#3	rahul
#4	bumrah
#2000	iyer
#2001	pant
#2002	axar



-- Ques 2
delimiter $
create procedure sal_comparision(id int)
begin
declare v1 int;
declare v2 numeric(11,2);
declare v3 numeric(11,2);
select salary into v1 from employees where employee_id=id;
select min(salary),max(salary) into v2,v3 from employees where job_id=(select job_id from employees where employee_id=id);
if(v1=v2) then 
select 'salary is minimum' compare;
elseif(v1=v3) then
select 'salary is maximum' compare;
else
select 'salary is neither minimum noe maximum' compare;
end if;
end $
delimiter ;
call sal_comparision(145);
drop procedure sal_comparision;
select * from employees where job_id='sa_man';


-- Ques 3
delimiter $
create function leap_year(d date)
returns varchar(30)
deterministic
begin
declare v1 varchar(30);
if(dayofyear(concat(year(d),'-12-31'))=366) then 
set v1='born in leap year';
else
set v1='not born in leap year';
end if;
return v1;
end $
delimiter ;
select leap_year('1900-08-09');
drop function leap_year;