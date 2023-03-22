use assignment;
with recursive cte as 
(select date('2001-05-18') 'da' union all select date_add(da,interval '1' year) from cte where cte.da<curdate()) 
select da 'date',dayname(da) 'dayname' from cte;
use demo;
select ename,sal,rank() over(order by sal)'rank',dense_rank() over(order by sal) 'dense' from emp;
select ename,sal,lead(sal) over(order by sal) 'lead',lag(sal) over(order by sal) 'lag' from emp;
select ename,deptno,sal,max(sal) over(partition by deptno) 'maxsal' from emp;
select ename from emp where hiredate=(select first_value(hiredate) 
over(order by hiredate desc)'junior' from emp limit 1);
use hr;
show triggers;