# Datatypes
# These are Vastly categorised under
# Numeric
# String
# Date

## Numeric
# 1.Tiny Int
create table tinyint_tab(c1 tinyint); 
insert into tinyint_tab values(124);
insert into tinyint_tab values(131);
# Error Code: 1264. Out of range value for column 'c1' at row 1
# Tiny int range is (-128 to 127)
insert into tinyint_tab values(-128);
select * from tinyint_tab;

# 2.Small Int
create table smallint_tab(c1 smallint);
insert into smallint_tab values(32766);
# Small int range is (-32768 to 32767)
insert into smallint_tab values(-32768);
select * from smallint_tab;

# 3. Medium Int
create table mediumint_tab(c1 mediumint);
insert into mediumint_tab values(1000000);
insert into mediumint_tab values(5000000);
insert into mediumint_tab values(8388607);
insert into mediumint_tab values(-8288608);
# Medium int range is (-8388608 to 8388607)

# 4.Int
# range (-2147483648 to 2147483647)
# 5.Bigint
# range (-9223372036854775808 to 9223372036854775807)


# 6.Decimal
create table deci(c1 decimal(4,4));
insert into deci values(0.83926);
# 7.Float
create table floa(c1 float(4,4));
insert into floa values(0.83926);

create table deci_floa(deci decimal,floa float);
insert into deci_floa values(123.4533,123.4533);
select * from deci_floa;

# decimal rounds to the nearest integer if precision is not mentioned but float rounds to the nearest third decimal

## Time
# 1.Time
create table time_tab(c1 time);
insert into time_tab values('11:09:08');
select * from time_tab; 
# 2.Datetime
create table datetime_tab(c1 datetime);
insert into datetime_tab values(now());
insert into datetime_tab values(sysdate());
insert into datetime_tab values('2022-09-08 12:09:08');
select * from datetime_tab;
# 3.Date
# 4.Timestamp
create table timestamp_tab(c1 timestamp);
insert into timestamp_tab values(now());
select * from timestamp_tab;
# IN oracle time stamp also imports the timezone in it
# 5.Year
create table year_tab(c1 year);
insert into year_tab values('2022');
select * from year_tab;

## String
# 1. Char
# 2. Varchar
# mysql supports varchar but oracle supports varchar2 
# the main difference between these two is char is fixed and varchar is floating
# 3.Text
# 4.Tiny text
# 5.Medium text
# 6.Long text

## Enum
create table enum_tab(c2 int,c1 enum('a','b','c'));
insert into enum_tab values(23,'a');
insert into enum_tab values(23,3);
select * from enum_tab;
# the values should only be in the specified values while table creation or less than the array length if num is given

## Boolean
create table boole(c1 boolean);
insert into boole values(127);
insert into boole values(null);
select * from boole;
desc boole;
create table bole(c1 bool);
desc bole;
insert into tinyint_tab values(true);

## Repeat Loop
delimiter $
create procedure rep_ex(p1 int,p2 int)
begin
repeat
set p1=p1+2;
until p1>p2
end repeat;
select p1;
end$
delimiter ;
call rep_ex(1,99);
# this is just like a simpleloop where the increments are normally made and the
# difference between both is that ion  simpleloop we explicitly need ti specify 
# the exit statement where over here once condition is satisfies the loop automatically exists.

## Cursor
#  cursor steps concists of delcare open fetch close
# declare defines cursor and associates it with a select statement
# syntax : <cursorname> cursor for select statement
# open statement initialises the result set for the cursor
# syntax : open <cursorname>
# fetch process the retrival of data from cursor resultset
# it retrives one row at a time
# each fetch will return succesive rows of the active result set, until entire set is returned\
# syntax : fetch <cursorname> into variable

-- procedure to pass deptno as parameter and select ename and sal row by row
delimiter $
create procedure pro_Cur(p1 int)
begin
declare v2 numeric(11,2);
declare v1 varchar(20);
declare res int default 0;
declare curemp cursor for select ename,sal from emp where deptno=p1;
declare continue handler for not found set res=1;
open curemp;
getrow : loop
fetch curemp into v1,v2;
if res=1 then
leave getrow;
end if;
select v1,v2;
end loop getrow;
close curemp;
end $
delimiter ;
drop procedure pro_cur1;
call pro_cur(30);

delimiter $
create procedure pro_cur1(p1 int)
begin
declare v2 numeric(11,2);
declare v1 varchar(20);
declare res int default 0;
declare c int;
declare curemp cursor for select ename,sal from emp where deptno=p1;
declare continue handler for not found set res=1;
select count(*) into c from emp where deptno=p1; 
set c=c+1;
open curemp;
getrow : loop
fetch curemp into v1,v2;
set res=res+1;
if res>=c then
leave getrow;
end if;
select v1,v2;
end loop getrow;
close curemp;
end $
delimiter ;
call pro_cur1(30);
select * from emp order by 2;

## Database Architecture
# Row->Pages->DataFiles->TableSpaces
#Information_Schema.files=> used to check tablespaces,datafiles,extents
select tablespace_name,file_name from information_schema.files limit 1;
select * from information_schema.files;
show variables like 'datadir';

select tablespace_name,file_name from information_schema.files where tablespace_name like 'hr%';
desc information_schema.files;

create table empset as select * from emp;
alter table empset modify column empno int primary key auto_increment;
insert into empset(ename,job,mgr,hiredate,sal,comm,deptno) 
select ename,job,mgr,hiredate,sal,comm,deptno from emp;
select * from empset;
insert into empset(ename,job,mgr,hiredate,sal,comm,deptno) 
select ename,job,mgr,hiredate,sal,comm,deptno from empset where ename<>'king';
select count(*) from empset;

select total_extents from information_schema.files where tablespace_name like '%empset%'; 
