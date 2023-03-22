use demo;
select * from emp;
select dname,ename from emp join dept using(deptno) where dname='sales';

-- find out common dname in grade 3,4
select dname from emp  
natural join dept
join salgrade on sal between losal and hisal 
where grade=4 and 
dname in (select dname from emp e 
natural join dept
join salgrade on sal between losal and hisal 
where grade=3);
-- using intersect
(select dname from emp e 
inner join dept d on e.deptno=d.deptno 
join salgrade on sal between losal and hisal 
and grade=4 )
intersect
(select dname from emp e 
inner join dept d on e.deptno=d.deptno 
join salgrade on sal between losal and hisal 
and grade=3);

select ename from emp order by sal desc limit 1;

-- intersect function works in the latest versions of mysql

-- Sub Query
-- it is called select inside select
-- it is also said as evaluating unknows through known
-- Rules
-- it executes first
-- result will be used by outer query and gets evaluated
-- subquery should be enclosed in brackets
-- (usually it is placed on the right side) 

-- find name who is taking max salary
select ename from emp where sal=(select max(sal) from emp);

-- find employees taking salary more than jones
select ename from emp where sal>(select sal from emp where ename='jones');

-- find dname where alan is working
-- using joins
select dname from dept natural join emp where ename='allen';
-- using sub query
select dname from dept where deptno=(select deptno from emp where ename='allen');

-- find out employees reporting to king
-- using joins
select e1.ename from emp e1 join emp e2 on e1.mgr=e2.empno and e2.ename='king';
-- using sub query
select ename from emp where mgr=(select empno from emp where ename='king');

-- find out employees working in accounting dept
-- using joins
select ename from emp natural join dept where dname='accounting';
-- using sub query
select ename from emp where deptno=(select deptno from dept where dname='accounting');

-- find out grade of turner
-- using joins
select grade from emp join salgrade on sal between losal and hisal where ename='turner'; 
-- using subquery
select grade from salgrade where 
(select sal from emp where ename='turner')>losal 
and 
(select sal from emp where ename='turner')<hisal;

select grade from salgrade where 
(select sal from emp where ename='turner') between losal and hisal;

-- find out junior most employee
select ename,hiredate from emp where hiredate=(select max(hiredate) from emp);

-- find out employees working with blake in the same depart ment and exclude blake
select ename,deptno from emp where deptno=(select deptno from emp where ename='blake') and ename!='blake';

-- find out employees who are taking same salaries as ward,fard
select ename , sal from emp where ename in ('ward','ford');
select ename from emp where sal in (select sal from emp where ename in ('ward','ford')) and ename not in ('ward','ford');

-- Types od Subquery
-- 1.Single row (=,<,>,<>)
-- 2.Multiple row ()
-- 3.Multiple column
-- 4.Nested
-- 5.Correlated

-- find out who joined in the same day as james and clark
select ename from emp where date_format(hiredate,'%W')
 in (select date_format(hiredate,'%W') from emp where ename in ('james','clark')) and ename not in ('clark','james');
 
-- find out dname in which no sales men are working
-- using sub query
select dname from dept where deptno not in (select distinct(deptno) from emp where job='salesman');

-- find out employees who have joined after allen martin,miller
select ename ,hiredate from emp;
select ename from emp where hiredate>(select max(hiredate) from emp where ename in ('allen','martin','miller'));
select ename from emp where hiredate>all(select hiredate from emp where ename in ('allen','martin','miller'));
-- find out employees who have taken more salary than allen martin,miller
select ename from emp where sal>all(select sal from emp where ename in ('allen','martin','miller'));
-- find out employees who are taking same salaries using sub queries
select ename,sal from emp where sal in(select sal from emp group by sal having count(*)>1);
-- find out employees who are taking maximum salary in each job
select ename,sal,job from emp where (sal,job) in (select max(sal),job from emp group by job);
