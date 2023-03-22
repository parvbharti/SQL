use demo;
## Partition tables
# Syntax:
create table emp_part(empno int,ename varchar(20),job varchar(20)) 
partition by list columns(job)(partition p_clerk values in ('clerk'),
partition p_anal values in ('analyst'),
partition p_sales values in ('salesman'),
partition p_manager values in ('manager'),
partition p_pres values in ('president')
);
## Explain plan
# it gives the plan without acually executing the query
explain select * from emp_part where job='clerk';
explain select deptno from emp where job='salesman'
union
select deptno from emp where job='clerk';
explain select ename from emp 
union
select dname from dept;
explain select ename,dname from emp natural join dept;

explain format=tree select * from dept where dname='sales';
explain select * from dept where deptno=10;
explain select * from emp where ename='smith';
explain select * from emp where hiredate='1981-12-03';
explain select * from regions where region_id=3;
explain select * from regions where location_id=1700;

create table fruit(id int,name varchar(20),qty int);

explain format=tree select * from emp;
insert into fruit values (103,'mango',70),(101,'apple',50),(105,'guava',65);
explain format=tree select * from fruit where name='apple';
explain format=tree select * from emp_seg where job='president';

insert into emp_part select empno,ename,job from emp;

explain format=tree select * from emp_part where job='president';
explain format=tree select * from dept where deptno=10;
explain format=tree select * from emp where ename='smith';
explain format=tree select * from emp where hiredate='1981-12-03';
explain format=tree select * from regions where region_id=3;
explain format=tree select * from departments where location_id=1700;

## Access Path
# 1.Tablescan when execution happens on table and no index is present
explain format=tree select * from emp_part where job='president';
# 2.Index when only column name which has index to it
explain format=tree select id from fruit;
# 3.Index Lookup when all rows are fetched using index column
explain format=tree select * from fruit where id=101;

## Index
# syntax create index <name> on table name(column name)
create index fruit_index on fruit(id);
explain format=tree select * from fruit where id=101;

# Index scan queries
explain format=tree select id from fruit;
explain format=tree select empno from emp;
explain format=tree select region_id from regions;
explain format=tree select location_id from locations;
explain format=tree select department_id from departments;
explain format=tree select employee_id from employees;

# Index Lookup queries
explain format=tree select * from employees where department_id=50;
explain format=tree select * from countries where region_id=4;
explain format=tree select * from departments where location_id=1700;
explain format=tree select * from salgrade where grade=1;

SELECT DISTINCT TABLE_NAME, INDEX_NAME,column_name FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'demo' and table_name='emp';
SELECT * FROM INFORMATION_SCHEMA. STATISTICS WHERE TABLE_SCHEMA = 'demo' and table_name='emp';

# one more method to create a index
alter table salgrade add index salgr(grade);
show create table emp;

explain select * from salgrade where grade=1;
explain select * from emp where empno=7566;
create index emppri1 on emp(empno);

-- find employees working in dept 20
-- check plan
-- optimise query
explain format=tree select * from emp where deptno=20;

-- find employees working in dept 20 and takins sal>950
-- check plan
-- optimise query
explain format=tree select * from emp where job='clerk' and sal>950;
alter table emp add index jobindex(job);

alter table emp drop index salindex;