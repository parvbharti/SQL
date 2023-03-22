-- Frame
-- Range Between Unbounded
-- in unbounded
-- unbounded preceeding - first row
-- un bounded following - last row
use demo;
select ename,sal,last_value(sal) over 
(order by sal range between unbounded preceding and unbounded following) 'last value' from emp;

select ename,sal,deptno,last_value(sal) over 
(partition by deptno range between unbounded preceding and unbounded following) 'last value' from emp;

select ename,sal,deptno,last_value(sal) over 
(partition by deptno order by sal range between unbounded preceding and unbounded following) 'last value' from emp;

select ename,job,hiredate,last_value(hiredate) over
(partition by job range between unbounded preceding and unbounded following) 'last value' from emp;

select ename,job,hiredate,last_value(hiredate) over
(order by job range between unbounded preceding and current row) 'last value' from emp;

select ename,job,hiredate,last_value(hiredate) over
(partition by job range between current row and unbounded following) 'last value' from emp;

-- CTE
-- it stands for common table expressions
with cte as (select * from emp) 
select ename from cte where deptno=10;

with cte as (select * from regions natural join countries)
select region_name,country_name from cte order by 1;

select ename,sal from emp e where sal>(select avg(sal) from emp where deptno=e.deptno);
-- convert the above query to cte
with cte as (select avg(sal) avgsal,deptno from emp group by deptno)
select ename,sal from emp e inner join cte c on c.deptno=e.deptno where e.sal>c.avgsal;

-- find out employee and his manager name
select e.ename employee,m.ename manager,e.deptno from emp e,emp m where e.mgr=m.empno order by 2;

with cte as (select count(*)co,deptno from emp group by deptno)
select e.ename employee,e.deptno,(select co from cte where deptno=e.deptno) count1,m.ename manager,m.deptno,
(select co from cte where deptno=m.deptno) count2 from emp e,emp m where e.mgr=m.empno order by 4;

with cte as (select ename,empno,deptno,count(*) over(partition by deptno)'count1' from emp)
select e.ename employee,e.deptno,(select count1 from cte where deptno=e.deptno limit 1) count1,
c.ename manager,c.deptno,c.count1 count2 from emp e inner join cte c on e.mgr=c.empno;

-- recursive cte
-- it is just as recursive function that executes until the statement condition is verified
with recursive cte as (select 1 'n' union all select n+1 from cte where cte.n<100)
select * from cte;

create table cte_table(c1 int);
insert into cte_table with recursive cte as (select 1 'n' union all select n+1 from cte where cte.n<100) select * from cte;

-- using normal loop generate lower case alphabets
delimiter $
create procedure lower()
begin
set @n=97;
set @r='';
while @n<=122 do
set @r=concat(@r,' ',char(@n using ascii));
set @n=@n+1;
end while;
select @r;
end $
delimiter ;
call lower();
drop procedure lower;

-- generate using recursice cte
with recursive cte as (select 97 'n' union all select n+1 from cte where cte.n<122) select char(n using ascii) from cte;

-- generate a dayname with date for entire january
with recursive cte as 
(select date('2022-01-01') 'da' union all select date_add(da,interval '1' day) from cte where cte.da<last_day(da)) 
select da 'date',dayname(da) 'dayname' from cte;

