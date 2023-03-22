use hr;
desc account;
desc trans;
insert into account values(12345690,'vineetha',50000);
select * from account;

-- create a trigger to update balance in account table whenever a deposit or withdrawal happens on trans table
delimiter $
create trigger tr 
before insert
on trans 
for each row
begin
if(new.dep is not null) then
update account set balance=balance+new.dep where accno=new.accno;
end if;
if(new.wd is not null) then
update account set balance=balance-new.wd where accno=new.accno;
end if;
end $
delimiter ;
insert into trans values(12345690,23000,30000);
insert into trans values(12345690,null,20000);
select * from account;
alter table account rename column balanace to balance;

create table date_tab(item_id int,date_of_pur date);

-- in trigger to print something signal is used
-- create a trigger to insert into date tab
delimiter $
create trigger dateins
before insert
on date_tab
for each row
begin
if(new.date_of_pur>curdate()) then
signal sqlstate '45000' set message_text='date of purchase shold be before or on current date';
end if;
end $
delimiter ;

insert into date_tab values(1,'2023-08-09');
select * from date_tab;

-- create a procedure to insert into date tab
delimiter $
create procedure dateinsert(p1 int,p2 date)
begin
insert into date_tab values (p1,p2);
end $
delimiter ;

call dateinsert(2,'2023=04=09');

-- create a trigger to increase salary of employee whenever location is changed
delimiter $
create trigger salinc
before update 
on departments
for each row
begin
if(new.location_id!=old.location_id) then
update emp1 set salary=salary+(salary*0.02) 
where department_id=(select department_id from departments where location_id=old.location_id);
end if;
end $
delimiter ;
select * from emp1 where department_id=20;
update departments set location_id=2700 where department_id=50;
select * from employees;

-- create trigger to restrict both username1 and password should not be same
create table login_tab(username varchar(20),password varchar(20));
select * from login_tab;
delimiter $
create trigger upsert
before insert
on login_tab
for each row
begin
if(new.username=new.password) then
signal sqlstate '45000' set message_text='user name and password sould not be the same';
end if;
end $
delimiter ;

delimiter $
create trigger upsert1
before update
on login_tab
for each row
begin
if(new.username=new.password) then
signal sqlstate '45000' set message_text='user name and password sould not be the same';
end if;
end $
delimiter ;

insert into login_tab values ('sai','naga');
insert into login_tab values ('naga','prasad');
insert into login_tab values ('naga','naga');
update login_tab set password='sai' where username='sai';
show triggers from hr;

create table region_new as select * from regions where 1=2;
delimiter $
create trigger insertregion
after insert 
on regions for each row 
begin
insert into region_new values(new.region_id,new.region_name);
end $
delimiter ;
insert into regions values(100,'srilanka');
select * from region_new;
delete from regions where region_id=100;

-- Procedure Parameter Modes
-- ---------------------------
-- In
-- Out
-- Inout

-- Out
delimiter $
create procedure pro_out(p1 int,out p2 varchar(20))
begin
select first_name into p2 from employees where employee_id=p1;
end $
delimiter ;
drop procedure pro_out;

call pro_out(101,@ster);
select @ster;

-- Inout
delimiter $
create procedure pro_inout(inout p1 varchar(20))
begin
select lpad(p1,25,'*')name;
end $
delimiter ;
drop procedure pro_inout;
set @name='rishi no choclate';
call pro_inout(@name);

-- Function           |           Procedure
-- --------------------------------------------
-- returns a value    |      out/inout returns
-- can be used        |      Not possible 
-- directly with SQl  | 
-- statements         |

-- Functions
delimiter $
create function fun1(p1 int)
returns varchar(20)
deterministic
begin
declare v3 varchar(20);
if(mod(p1,2)=0) then
set v3='even';
else
set v3='odd';
end if;
return v3;
end $
delimiter :

set @v1=fun1(115);
select @v1;
select employee_id,fun1(employee_id) from employees where department_id=60;

-- create a function to pass employee_id as parameter and return joined in laep_year or not
delimiter $
create function leap(p1 int)
returns varchar(20)
deterministic
begin
declare v1 varchar(30);
declare v2 date;
select hire_date into v2 from employees where employee_id=p1;
if(date_format(concat(year(v2),'-12-31'),'%j')=366) then
set v1='leap year joined';
else
set v1='non leap year joined';
end if;
return v1;
end $
delimiter ;
select employee_id,leap(employee_id) 'leap_joined',year(hire_date) from employees where leap(employee_id)='leap year joined';