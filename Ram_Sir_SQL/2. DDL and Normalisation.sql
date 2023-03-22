-- Constraint 
-- * Regulate Data
-- Types
-- -- not null => data should cumpulsorily be entered
-- -- unique => data that is to be entered must not be same for two rows
-- -- primary => data cannot be null and should be unique
-- -- composite => if more than one feild in a table are to be make primary then this is used
-- -- foreign => if a table needs to be connected with other table then foreign key constraint is used
			--   the table which is using the key is child table and table connested to is parent table
-- -- Check => To check for a specific condition
-- -- default => data if not entered default value specified will be filled in it
show columns from emp;
create table atm(cardno numeric(16) not null, pin numeric(6) not null);
-- when not null is being given to any feild in the data null value cannot be given to that purticular data
desc atm;
insert into atm values(2143615361512123,917361);
insert into atm values(1212123212321232,761736);
insert into atm values(2142815224186423,912361);
insert into atm values(1212123213618232,281636);

-- unique
-- if not null is not enabled it allows to store many null values but not duplicate values
-- if not null is enables only one null value can be inserted
select * from atm;
create table rto (regno varchar(10) unique,vehicle varchar(10));
desc rto;
insert into rto values('ka23eg1651','car');
insert into rto values('ka25whhayq','bike');

-- primary
create table account(accno int primary key,name varchar(20),balance numeric(11,2));
desc account;
insert into account values(173518,'sai','17251.28');
insert into account values(127268,'rishitha','172271.28');
insert into account values(168721,'teja',716715261);
select * from account;

-- composite
create table comptable(adhno numeric(12),panno varchar(12),passportno varchar(10),empno varchar(10),name varchar(25),dob date,primary key(adhno,panno,passportno,empno));
desc comptable;

-- when constraints are defined during the table creation itself then it is called table level constraint generation
-- when contraints are given to the table after its creation using alter statement then it is called column level contraint generation

-- foreign 
-- foreign key value can have duplicate values
-- it also accepts null values until not null constraint is not specified
-- values depend on the parent table
create table trans(accno int,wd numeric(11,2),dep numeric(11,2),foreign key(accno) references account(accno));
desc trans;
insert into trans values(127268,1231,12121);
insert into trans values(168721,1723,18261);
insert into trans values(173518,17251,6617);
insert into trans values(173518,17227,6117);
select * from trans;
insert into trans values(null,1751,8218);

-- check
create table vote(name varchar(20), age numeric(3) check (age>=18));
insert into vote values('sai',21);
insert into vote values('rishi',143);
insert into vote values('karishma'17);
-- error occus as age is less than 18 and consdition is not met
 
-- create a table called metrocities having values citiid,citiname and shouls allow only metro politan cities
create table metrocities(citiid int primary key,cityname varchar(20) check(cityname in ('delhi','mumbai','chennai','kolkata')));
insert into metrocities values(20,'kolkata');
insert into metrocities values(21,'mumbai');
insert into metrocities values(22,'chennai');
insert into metrocities values(23,'delhi');

-- view
drop view stud_age;
create view stud_age as select id,name,ceil((curdate()-dob)/(365*30)) "age" from student;
select * from stud_age;

-- three level architecture
-- external 	end users					user level
-- conceptual	devlopers/programmers		global level
-- internal		database architectire		storage level

-- purpose of 3 level architecture
-- 1. data abstraction
-- 2. data independence

-- Data Independence 
-- >>Ability of higher level of abdtraction not to be affected by changes in lower level of abstraction
-- types of data independence
-- 1)logical   external and conceptual
-- 2)physical  conceptual and internal

-- Normalization
-- it is a decomposition process having the following
-- 1) to remove redundancy
-- 2) remove data anamolies (Insert ,Update ,Delete)

-- different normal forms
-- 1NF - Ensures atomic values and repeating columns
-- 2NF - Removes partial dependency
-- 3NF - removes transitive dependency
