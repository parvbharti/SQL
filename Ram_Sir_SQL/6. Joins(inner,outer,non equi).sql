use demo;
-- the number of columns projected should be same in the union
select job from emp where deptno=10 union select deptno from emp where deptno=20;
-- union is internally concatination where one row is merged with corresponding row of second query and datatype does'nt matter

-- display total salary for each job along with total salary
select sum(sal),job from emp group by job union select sum(sal),'Total Salary' from emp;
select sum(sal),job from emp group by job with rollup;
-- rollup
-- it gives the summary values for the row values
-- it only works with group by clause
-- when multiple columns are used summary values for first column in group by is only printed
select sum(sal),job,deptno from emp group by deptno,job with rollup;
-- cube
-- it also gives summary values
-- it gives summary for two columns
-- it doesnt work with mysql, only works in oraclesql and sqlserver
select sum(sal),job,deptno from emp group by cube(deptno,job);

-- add null columns in union 
select ename,null dname from emp union select null,dname from dept;

desc emp;
desc dept;
select ename,dname from emp inner join dept on emp.deptno=dept.deptno;

-- there are 2 syntaxes in joins
-- 			oracle prop		|		SQL-99
-- ----------------------------------------------
-- 			equi 			|		inner	
-- 			non equi		|		join
-- 			outer			|		outer
-- 			self			|		join
-- 			cartisian		|		cross
-- 							|		natural
--   						|		using

-- rules
-- 1. columns should have the format like the first letter of the table is used as its alias
-- 2. type of join needs to be specified (inner,outer,cross,...)
-- 3. join condition uses on clause which is y join is also called as on clause statements

-- inner join
-- this is used generally for tables with referential integrity
-- join condition uses equals operater which is y it is called equi join in oracle sql.
-- syntax :
-- select col1,col2,.. from table1 inner join table2 on condition
-- additional conditions can be used by where clause,and operator
select ename,dname from emp inner join dept on emp.deptno=dept.deptno;
-- display location for each employee
select ename,loc from emp inner join dept on emp.deptno=dept.deptno;
-- display above output only for dallas
select ename,loc from emp inner join dept on emp.deptno=dept.deptno where loc='dallas';
-- display dname,job only for clerk
select ename,dname,job from emp inner join dept on emp.deptno=dept.deptno where job='clerk';
-- find out no of employees working in each dname
select dname,count(ename) 'employee count' from emp inner join dept on emp.deptno=dept.deptno group by dname;
-- display average(salary),dname which are having more than three employee
select avg(sal) 'average salary',dname from emp inner join dept on emp.deptno=dept.deptno group by dname having count(ename)>3;

use hr;
desc regions;
desc countries;
-- display region name along with country name
select region_name,country_name from regions inner join countries on regions.region_id=countries.region_id;
-- display no of countries for each region
select count(country_name),region_name from regions inner join countries on regions.region_id=countries.region_id group by region_name;
-- display the highest amoung the above table
select count(country_name),region_name from regions inner join countries on regions.region_id=countries.region_id group by region_name order by 1 desc limit 1;
-- using inline view
select region_name,max(a.cnt) from (select count(country_name) cnt,region_name from regions inner join countries on regions.region_id=countries.region_id group by region_name)a; 

-- Outer Join
-- If the missing data is also required in the joined table outer join is preffered
-- it can be simply said by the combination of inner join with the missing data
-- there are three types 
-- 1. right outer join
-- 2. left outer join
-- 3. full outer join
-- my sql does not support full outer join but can be achived by union of right and left outer join
select ename,dname from dept right outer join emp on emp.deptno=dept.deptno;
use demo;
start transaction;
insert into emp(empno,ename) values(1111,'x');
-- full outer join
select ename,dname from dept left outer join emp on emp.deptno=dept.deptno union select ename,dname from dept right outer join emp on emp.deptno=dept.deptno;
use hr;
select first_name,departments.department_id from employees 
right outer join departments on employees.department_id=departments.department_id;

select first_name,departments.department_id from employees 
left outer join departments on employees.department_id=departments.department_id;

select first_name,departments.department_id from employees 
right outer join departments on employees.department_id=departments.department_id 
union 
select first_name,departments.department_id from employees 
left outer join departments on employees.department_id=departments.department_id;

-- non equi join
-- this uses other than = operator from joining tables
use demo;
select ename,grade from emp,salgrade where emp.sal between salgrade.losal and salgrade.hisal;
select ename,grade,dname from emp join salgrade on emp.sal between salgrade.losal and salgrade.hisal inner join dept on emp.deptno=dept.deptno;
-- oracle sql proprietary syntax that also works in my sql
select e.ename,s.grade,d.dname from emp e,salgrade s,dept d where e.sal between s.losal and s.hisal and d.deptno=e.deptno;