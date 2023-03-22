-- window keyword
-- it is just like alias
select first_name,salary,row_number() over w 'row',
rank() over w 'rank',
dense_rank() over w 'dense'
from employees 
window w as (order by salary);

-- display the running salary
select first_name,salary,sum(salary) over(order by salary)'running salary sum' from employees;
-- using corelated subqueries
select employee_id,salary,(select sum(salary) from employees where employee_id<=c.employee_id) 'running sal' from employees c;

set @t_salary = 0;
select first_name,salary,@t_salary:=salary+@t_salary 'rsum' from employees order by salary;

select first_name,salary,lead(salary,1,1) over(order by salary) from employees;
-- first 1 is for the token which is printed and second is the value which comes instead of null

-- First_value
select ename,sal,first_value(sal) over(order by sal desc) 'first' from emp;
-- Last_value
select ename,sal,last_value(sal) over(order by sal desc) 'last' from emp;
-- nth_value
select ename,sal,nth_value(sal,2) over(order by sal desc) '2nd high sal' from emp;
-- find difference between first and last joined employees and also their dates
select lasthiredate,firsthiredate,datediff(lasthiredate,firsthiredate) 
from (select nth_value(hiredate,1) over(order by hiredate desc) 'lasthiredate',nth_value(hiredate,1) over(order by hiredate)
 'firsthiredate' from emp limit 1)c;

delimiter $
create function age(d date)
returns int
deterministic
begin
declare y int;
set y=timestampdiff(year,d,curdate());
return y;
end $
delimiter ;
drop function age;
select age('2001-05-18');
