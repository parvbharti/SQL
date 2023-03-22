create database formedhr;
select specific_name,routine_type from information_schema.routines where routine_schema='formedhr';
-- when mysql dump is used for exporting the database then triggers are not imported when mysql is used 
-- to tackle this we use --routines in the mysql dump command
-- the final line is
-- mysqldump -u root -p --routines hr>routines.sql
drop database formedhr;
use hr;
select * from employees;

-- create a user defined function to pass employee_id as parameter and return bonus
-- sa_rep=1.75*sal
-- sh_clerk=1.5*sal
-- mk_rep=2.0*sal
-- remaining job_id's bonus=sal

delimiter $
create function bonus(id int)
returns numeric(10,2)
deterministic
begin
declare b numeric(10,2);
declare j varchar(20);
select job_id,salary into j,b from employees where employee_id=id;
if(j='sa_rep') then 
set b=b*1.75;
elseif(j='sh_clerk') then 
set b=b*1.5;
elseif(j='mk_rep') then 
set b=b*2;
else
set b=b*1;
end if;
return b;
end $
delimiter ;
select employee_id,salary,bonus(employee_id) as bonus,job_id,first_name from employees order by 4;

-- assignment
-- employees will be paid joing bonus after 1 year
-- if they joined before 15th then bones is given on last friday of 13th month
-- if they joined after 15th then bonus is given on last saturday of 14th month
delimiter $
create function bonuson(id int)
returns date
deterministic
begin
declare d int;
declare bdate date;
declare bonus date;
select day(hire_date),hire_date into d,bdate from employees where employee_id=id;
if(d<16) then
set bonus=date_add(bdate,interval '12' month);
set bonus=last_day(bonus);
while(dayname(bonus)!='friday') do
set bonus=date_sub(bonus,interval '12' day);
end while;
else
set bonus=date_add(bdate,interval '13' month);
set bonus=last_day(bonus);
while(dayname(bonus)!='friday') do
set bonus=date_sub(bonus,interval '1' day);
end while;
end if;
return bonus;
end $
delimiter ;
use hr;

