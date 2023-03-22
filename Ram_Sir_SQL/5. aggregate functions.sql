set @@sql_mode='only_full_group_by';
use hr;
use demo;
select deptno,ename from emp order by 1;

-- Aggregate functions
-- >> count
-- >> min
-- >> max
-- >> avg
-- >> sum
-- >> group_concat()

select count(*),min(sal),max(sal),sum(sal),avg(sal),deptno from emp;
-- gives error as the full group by is been set in the sql mode
select count(*),deptno from emp group by job;
-- gives error as the columns used for retrival and group by are different
select count(*),min(sal),max(sal),sum(sal),avg(sal) from emp;

-- find the number of employees who joined in each quarters
select count(*),quarter(hiredate) from emp group by quarter(hiredate);
-- find the employees who joined in the each quarter of each year
select count(*),year(hiredate),quarter(hiredate) from emp group by year(hiredate),quarter(hiredate);
-- find the employees who joined in the each month of each quarter of each year
select count(*),monthname(hiredate),quarter(hiredate),year(hiredate) from emp group by monthname(hiredate),quarter(hiredate),year(hiredate);

select sum(sal),deptno from emp group by deptno;
-- find tot salary and avg salary foe all the employees excluding analyst
select sum(sal),avg(sal),job from emp where job<>'Analyst' group by job;
-- find out number of employees taking same sal
select count(*),sal from emp group by sal;

-- where is used for single row restriction
-- having is used for group restriction
-- where cannot be used for aggregate functions
select count(*),sal from emp group by sal having count(*)>1;

-- find num of employees who joined on same date
select count(*) count,hiredate from emp group by hiredate having count(*)>1;

-- donot use having where ever where works
-- because having is used after grouping but where occurs before grouping


-- if job=clerk display count
-- job = salesman display max(Sal)
-- job = analyst display total sal
-- else display sal
select job,case
when job='clerk' then concat("number of clerks=",count(*))
when job='salesman' then concat('max salary=',max(sal))
when job='analyst' then concat('sum of salary=',sum(sal))
else concat('average salary=',avg(sal)) 
end 'condition'
from emp group by job;

select job,case job
when 'clerk' then concat("number of clerks=",count(*))
when 'salesman' then concat('max salary=',max(sal))
when 'analyst' then concat('sum of salary=',sum(sal))
else concat('average salary=',avg(sal)) 
end 'condition'
from emp group by job;


-- update emp set sex=  CASE sex when 'm' then 'f' ELSE 'm' end;

-- find the max number of employees doing a purticular job
select count(*) from emp group by job order by 1 desc limit 1;
-- aggregate(aggregate) is not allowed in my sql
-- this can be done using 
-- >> inline view
-- >> cte

-- inline view
-- in sql server it is called derived table
-- it is a subquery with a name
-- syntax : (select * from emp) e
-- by this command the table generated with in the query is stored as a table with name e

-- find the max number of employees doing a purticular job
select max(a.cnt) from (select count(*) cnt from emp group by job)a;
-- find out jobs in deptno 10 & 20
select distinct(job) from emp where deptno in (10,20);
select job from emp where deptno in (10,20) group by job;

-- find out different types of commision taken in emp
select distinct(count(comm)) from emp;
select distinct(comm) from emp;
-- if count is done on a purticular column then null is been neglected

-- SET Operators
-- these are used to select data from similar select statements
-- Types
-- >> union
-- >> union all
-- >> intersect
-- >> minus/ except

-- mysql does not support minus
-- it is suppoerted by mariadb

-- RULES
-- >> Number of colmns should be same in all select statements

-- select statement union select statement
select job from emp where deptno=10 union select job from emp where deptno=20;
-- if duplicates need to be printed union all is used
select job from emp where deptno=10 union all select job from emp where deptno=20;

-- if union is ruuned on oracle duplicates are removed and also data is automatically sorted
select job from emp where deptno=10 
union
select job from emp where deptno =20 order by job;
-- order by should only be used after all select statement yet it only works for the first select statement
select ename from emp union select dname from dept order by ename;
-- column heading comes from the first select statement
-- datatype is also not mandatory

-- display total salary for each job as well as total salary
select sum(sal) from emp group by job union select sum(sal) from emp;