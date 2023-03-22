use demo;
explain select ename,hiredate from emp where hiredate in (select max(hiredate) from emp);
explain select region_name,country_name from hr.regions natural join hr.countries;
show indexes from dept;
explain format=tree select * from hr.regions where region_id=1;

-- select
-- it has
-- parsing - checks syntaxes and privilages
-- optimising - prepares the plans
-- executing - executes plans prepared
-- fetching - if the function is select rows will be fetched

-- in my sql automatic creation of indexes happens
-- 1. primary
-- 2. unique
-- 3. foreign

create table uni_tab (c1 int unique,c2 char);
insert into uni_tab values(1,'a'),(2,'b'),(3,'c');
select * from uni_tab;
explain select * from uni_tab where c2='c';

explain select * from dept where deptno=20;
show create table dept;
-- type has
-- 1. all - no constraint like primary unique or foreign
-- 2. ref - foreign
-- 3. const - primary / unique
-- 4. index - created index on a column
-- 5. index_merge - if where clause has two rows which intern are having indexes
-- 6. range - if > or < is given then range comes


explain format=tree select * from hr.countries where country_id=1700;

-- find employees working in dept 20 as clerk
explain format=tree select ename from emp where deptno=20 and job='clerk';
create index inx on emp(job);

-- to change the default behavior of optimiser and to select our own index then 
-- we can use 
-- use index
-- force
-- ignore
show indexes from emp;
explain format=tree select * from emp force index (inx) where deptno=20 and job='clerk';

-- invisible indexes
-- 1. by default all indexes are visible
-- Advantages
-- 1. invisible index can help in a great extent by jsut making the index usable
-- or not instad of deleteing and recreating it
-- 2. indexes can be created for certain adhoc queries which are fired infrequently
-- and can be made visible after usage
show indexes from emp;
explain select * from emp where job='clerk';
alter table emp alter index inx invisible; -- make the index invisible
explain format=tree select * from emp where job='clerk'; -- cost = 1.65
alter table emp alter index inx visible; -- make the index visible
explain format=tree select * from emp where job='clerk'; -- cost = 0.90
show indexes from emp;
-- Practice
-- find employees who are working as clerk in deptno 20 and as clerk
select ename from emp where deptno=20 and job='clerk';
-- check the plan
explain format=tree select ename from emp where deptno=20 and job='clerk'; -- cost=0.86
-- make deptno index invisible
alter table emp alter index fk_deptno invisible;
-- check the plan
explain format=tree select ename from emp where deptno=20 and job='clerk'; -- cost=0.63
-- make it visible again
alter table emp alter index fk_deptno visible;
-- make job index invisible
alter table emp alter index inx invisible;
-- check the plan 
explain format=tree select ename from emp where deptno=20 and job='clerk'; -- cost=0.60
-- make both visible
alter table emp alter index inx visible;
-- check the plan
explain format=tree select ename from emp where deptno=20 and job='clerk'; -- cost=0.86
-- make a composite index
create index comp on emp(deptno,job);
-- check the plan
explain format=tree select ename from emp where deptno=20 and job='clerk'; -- cost=0.70
-- make it invisible
alter table emp alter index comp invisible;
-- check the plan
explain format=tree select ename from emp where deptno=20 and job='clerk'; -- cost=0.63
-- make it invisible
alter table emp alter index comp visible;
-- check the plan
explain format=tree select ename from emp where deptno=20 and job='clerk'; -- cost=0.63


-- Unused Indexes
-- To check the indexes created by the users for some purpose
select * from sys.schema_unused_indexes;

-- drop an index
drop index inx on emp; 
-- rename an index
alter table emp rename index comp to composite;

show indexes from emp;

-- leading columns wiil be utilizing the composite index but not the second
explain format=tree select * from emp where job='clerk'; -- not use composite
explain format=tree select * from emp where deptno=30; -- use composite

-- Range partition
create table range_emp(emp int,ename varchar(30),sal int)
partition by range(sal)
(
partition p_1000 values less than (1000), 
partition p_2000 values less than (2000), 
partition p_3000 values less than (3000), 
partition p_4000 values less than (4000), 
partition p_max values less than maxvalue
);

insert into range_emp select empno,ename,sal from empset;
insert into range_emp values(200,'sai',9000);
select * from range_emp partition(p_max);

-- to check the number of rows in each partition
select partition_name,partition_ordinal_position,table_rows 
from information_schema.partitions where table_name='range_emp';

create table range_hiredate_emp(emp int,ename varchar(30),hiredate date,sal int)
partition by range(year(hiredate))
(
partition p_1980 values less than (1980), 
partition p_1981 values less than (1981), 
partition p_1982 values less than (1982), 
partition p_1987 values less than (1987), 
partition p_max values less than maxvalue
);
insert into range_hiredate_emp select empno,ename,hiredate,sal from empset;
select partition_name,partition_ordinal_position,table_rows 
from information_schema.partitions where table_name='range_hiredate_emp';

explain select count(*) from range_hiredate_emp where year(hiredate)>1987;

insert into range_hiredate_emp values (1,'sai','1979',3004);
insert into range_hiredate_emp select empno,ename,date_format(hiredate,'%Y'),sal from empset;