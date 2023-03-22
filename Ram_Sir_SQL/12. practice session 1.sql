-- create table dept_tab with id,name as columns
create database practice;
create table dept_tab(id int(4),name varchar(25));
-- add auto increment to id
alter table dept_tab modify column id int(4) primary key auto_increment;
-- set auto increment to 1000
alter table dept_tab auto_increment=1000;
-- insert data
insert into dept_tab(name) values ('prithvi'),('agni'),('agni'),('trishul');
select * from dept_tab;
-- add a column called location with datatype varchar of size 15
alter table dept_tab add column location varchar(15);
-- update location with 'banglore' 'chennai' 'hyderabad' 'delhi' for all the rows
update dept_tab set location='banglore' where id=1000;
update dept_tab set location='chennai' where id=1001;
update dept_tab set location='hyderabad' where id=1002;
update dept_tab set location='delhi' where id=1003;
-- rename column location as place
alter table dept_tab rename column location to place;
-- rename the table as itpl_tab
alter table dept_tab rename to itpl_tab;
-- drop constraint primary key;
show create table itpl_tab;
alter table itpl_tab modify column id int; -- this will not work
alter table itpl_tab drop primary key;
#another method
alter table itpl_tab modify column id int, drop primary key;
-- create itpl.bak using itpl_tab
create database itpl;
create table itpl.bak as select * from itpl_tab;
-- drop table itpl_tab
drop table itpl_tab;