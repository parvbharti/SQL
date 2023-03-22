show databases;
select database();
use hr;
select * from ipl_table;

-- how to check if a column has auto increment in it or not
desc ipl_table;
start transaction;
insert into ipl_table values(9,'kkr');
insert into ipl_table(name) values('gl');
rollback;

-- when a tuple is inserted with our specifying the column with auto increment then the highest value 
-- is been taken as the base number upon which the next number is taken
select table_name,auto_increment from information_schema.tables where table_name='dep_new1' and table_schema='hr';
-- this below method is better as above one may show false outputs in some scenarios
select last_insert_id();
-- this gives the last value that is inserted in the data base

create table dep_new1(deptno int primary key auto_increment,deptname varchar(20));
insert into dep_new1(deptname) values ('cloud');
select * from dep_new1;
select * from departments;

select last_insert_id();
-- this gives the last value that is inserted in the data base

-- auto increment is done with primary key
-- it generates sequential numbers
-- in mysql we acn insert for auto_increment maually
-- gaps may occur here
-- to fill these we need to fill them manually
create table num(slno int,date1 date);
insert into num values(1,date_sub(curdate(),interval '1' day)),
(2,date_sub(curdate(),interval '2' day)),
(3,date_sub(curdate(),interval '3' day)),
(4,date_sub(curdate(),interval '4' day)),
(5,date_sub(curdate(),interval '5' day)),
(6,date_sub(curdate(),interval '6' day)),
(7,date_sub(curdate(),interval '7' day));
select * from num;
alter table num modify slno int primary key auto_increment;
desc num;
insert into num(date1) values(date_sub(curdate(),interval '10' day));

-- change the auto increment
alter table num auto_increment=100;
insert into num(date1) values(date_sub(curdate(),interval '11' day));
select * from num;
select last_insert_id();

use demo;
show tables;
desc oe_tab;
-- desc doesnot show if there is any check constarint that is added to the table that can be viewed using--
show create table oe_tab;

-- Default
create table default_tab(c1 int primary key,c2 timestamp default current_timestamp);
desc default_tab;
insert into default_tab(c1) values(100);
select * from default_tab;
insert into default_tab values(2,curdate());
-- inserting using default
insert into default_tab values(101,default);
-- change default value
alter table default_tab alter c2 set default '2022-09-01';

--       Drop          |       Truncate
-- ------------------------------------------
--   removes structure |  Reatains structure
--   removes data      |  removes data

--        Delete          |        Truncate
-- ----------------------------------------------
--   can use where clause |      cant use where 
--   we can roll back     |      cant roll back


-- Alter Table
--  * Add Clause ==> add new columns,add new contraints
--  * Modify/Change ==> change null to not null,change column names,column definations
--  * Alter ==> default values
--  * Drop Clause ==> drop columns,drop constraints
--  * Rename Clause ==> rename tables,columns

create table alter_tab(c1 int,c2 date,c3 char,c4 numeric(11,2));
desc alter_tab;

-- add columns
alter table alter_tab add column c5 varchar(20);
-- by default the column is added as the last of table

-- add columns at the specified place
alter table alter_tab add column c6 int first;

-- add column after a purticular column
alter table alter_tab add column c7 int after c3;

-- add constraints
-- the constraints that are possible are primary,unique,foreign and check function

-- adding check constraint
alter table alter_tab add constraint check(c3 in ('a','b'));
-- adding primary key constraint
alter table alter_tab add constraint primary key(c1);
-- adding unique key constraint
alter table alter_tab add constraint unique(c1);
-- adding foreign key
create table t2(c2 date primary key);
alter table alter_tab add constraint foreign key(c2) references t2(c2);
-- a name can also be given to the constraint added
alter table alter_tab add constraint unq_1 unique(c4);
-- here unq_1 is the constraint name that can be used for the future reference
show create table alter_tab;

-- modify
-- modyfying datatype
alter table alter_tab modify c3 varchar(20);
-- modify constraint
alter table alter_tab modify c5 timestamp not null;
desc alter_tab;
use hr;
desc employees;
desc num;
-- alter to change the size of datatype
alter table num modify slno numeric(10,2);
insert into num values(10000,curdate());
select * from num;


alter table num modify slno numeric(3,2);
-- executing the above code gives error as there is a value 1000 in slno and change the datatype and 
-- decresing its size to 3 may not have the 1000 to size three so that does not occur

use hr;
alter table default_tab alter c2 set default '2018-12-25';

-- Rename
-- renameing table
alter table alter_tab rename to alter_table;
desc alter_table;
-- renameing column
alter table alter_table rename column c2 to ctwo;

-- Drop
-- dropping constraint
alter table alter_table drop primary key;
show create table alter_table;
alter table alter_table drop constraint alter_table_ibfk_1;
-- alter_table_ibfk_1 is the constraint name
-- dropping column
alter table alter_table drop column c7;
-- dropping table
drop table if exists alter_tab;

-- whenever referential integrity is available between tables we cant drop table/column/contraints
-- we need to use on delete cascade,on delete set null
create table pri_tab(c1 int primary key,c2 char);
create table for_tab(c1 int,c3 date,foreign key(c1) references pri_tab(c1));
insert into pri_tab values(1,'a');
insert into for_tab values(1,curdate()),(1,'2023-01-03');
insert into for_tab values(1,'2022-01-00');
delete from pri_tab;
-- Cannot delete or update a parent row: a foreign key constraint fails 
-- (`demo`.`for_tab`, CONSTRAINT `for_tab_ibfk_1` FOREIGN KEY (`c1`) REFERENCES `pri_tab` (`c1`))
show create table for_tab;
alter table for_tab drop constraint for_tab_ibfk_1;
alter table for_tab add constraint foreign key(c1) references pri_tab(c1) on delete cascade;
start transaction;
delete from pri_tab;
select * from for_tab;
-- all values are deleted
rollback;
alter table for_tab drop constraint for_tab_ibfk_1;
alter table for_tab add constraint foreign key(c1) references pri_tab(c1) on delete set null;
start transaction;
delete from pri_tab;
select * from for_tab;
-- the id column of the table is set null for all the ids that are deleted in the pri_tab table
rollback;

-- table names should cannot have .,*,\,space,-,#
-- _ is allowed
-- duplicate existing table name
-- no reserved words

-- if we want to give name for constraint then we need to define using table level coding
