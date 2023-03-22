use demo;
explain select * from emp where empno>7839;
explain select * from range_hiredate_emp where hiredate between '1981-01-01' and '1981-12-31';

-- Hash Partition
-- Database will have control on the partitions
-- we need to specify number of partitions
-- data will be uniformely distributed

create table hash_tab(empno int primary key,ename varchar(20),sal int)
partition by hash(empno) partitions 4;
insert into hash_tab select empno,ename,sal from empset;

explain select * from hash_tab where empno=100;
explain select * from hash_tab where empno=10000;
explain select * from hash_tab where empno=1;
select count(*) from hash_tab where partitions=p0;

select partition_ordinal_position,table_rows,partition_method from information_schema.partitions where table_name='hash_tab';

-- Composite
-- you can have main partition(range/list)
-- subpartition hash
create table comp_part(empno int,ename varchar(20),sal int,jab varchar(30))
partition by range(sal)
subpartition by hash(empno)
subpartitions 2
(
partition p_1000 values less than (1000), 
partition p_2000 values less than (2000), 
partition p_3000 values less than (3000), 
partition p_4000 values less than (4000), 
partition p_max values less than maxvalue
);
insert into comp_part select empno,ename,sal,job from empset;
select partition_name,table_rows,subpartition_name from information_schema.partitions where table_name='comp_part';

-- temporary tables
-- data availability is temporary
-- temporary table need to be used during creation
-- drop or truncate is not nessesary
create temporary table temp_emp select sal from emp;
select * from temp_emp;
show tables;
-- advantages
-- simplify coding
-- simulate cursors when processing data from multiple tables
-- improve performance in a situation where multi-table joins are needed
-- associate rows from queries in one result set(union)
-- eliminate re querying data needed for joins
-- consolidate the data for decision support data requirements
-- temp table in mysql will dropped automatically when the user closes the session or terminates the connection manually

explain format=tree select sum(sal) from hash_tab;
create index sal_inx on hash_tab(sal);
explain format=tree select sum(sal) from hash_tab;

explain format=tree select count(*),job from empset force index(sal_idx) where job in('analyst','clerk') group by job;

create index sal_idx on empset(sal);

explain format=tree select sum(sal),job from emp group by job
union
select sum(sal),null from emp;

explain format=tree select sum(sal),job from emp group by job with rollup;

explain format=tree select job,max(sal) from empset group by job having job in('salesman','clerk');
explain format=tree select job,max(sal) from empset where job in('salesman','clerk') group by job;
show indexes from empset;

create table emptest as select * from emp;
create table depttest as select * from dept;
select * from depttest;
select * from emptest;

-- display employees who are clerk and work in chicago
explain format=tree select ename from emptest natural join depttest where loc='chicago' and job='clerk'; 
-- optimise it
-- create index 
create index job_in on emptest(job); #cost=1.55
create index loc_in on depttest(loc); #cost=1.25
drop index com_ind on emptest;
drop index loc_in on depttest;
create index com_ind on emptest(ename,deptno,job);
create index comp_ind2 on depttest(deptno,loc); # mixed cost=2.26

show create table emp;
show engines;

create table engine_tab(c1 int) engine=memory;

show create table engine_tab;

-- Index
-- Types are
-- 1. unique
-- 2. non unique
-- 3. functional index
-- 4. btree
-- 5. hash
-- 6. geo-spatial index

create index date_ind on emp(hiredate);
explain format=tree select ename from emp where monthname(HIREDATE)='january';
alter table emp add index((monthname(hiredate)));
show indexes from emp;

# hash index need to be created in memory as it occupies more memory
create table testhash(fname varchar(50) not null,lname varchar(50) not null,key using hash(fname))engine=memory;

insert into testhash select first_name,last_name from hr.employees;

show indexes from testhash;
show indexes from emp;

-- optimiser join are of two types
-- 1. hash joins
-- 2. nested loops

create table full_t as select first_name ,last_name from hr.employees;
alter table full_t add fulltext(first_name,last_name);
show indexes from full_t;

select * from full_t where match(first_name,last_name) against ('Alexander%');