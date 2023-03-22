use demo;
select count(*),max(sal),min(sal),sum(Sal),avg(sal) from emp;

-- find max salary for each job_id in employees table
use hr;
select max(salary),job_id from employees group by job_id order by job_id;

select first_name,salary,job_id from employees where (job_id,salary) in
 (select job_id,max(salary) from employees group by job_id order by job_id);
 
 -- windowing functions             |          aggregate functions
 -- --------------------------------------------------------------
 --  with out group by it can be    |     group by is a must
 --  accomplished                   |
 
 -- there are two types of window functions
 -- 1. over
 -- 2. partition
 
 -- Over
 select first_name,count(*) over()  as cnt from employees;
 select first_name,min(salary) over()  as max from employees;
 select first_name,max(Salary) over()  as min from employees;
 select first_name,avg(salary) over()  as avg from employees;
 select first_name,sum(Salary) over()  as sum from employees;
 
  select first_name,count(*) over()  as cnt,
  min(salary) over()  as max,
  max(Salary) over()  as min,
  avg(salary) over()  as avg,
  sum(Salary) over()  as sum from employees;
  
  -- Partition
  select first_name,job_id,salary,max(Salary) over(partition by job_id) as 'max salary' from employees order by 2;
  
  -- Ranking Functions
  -- ------------------
-- it is used to give serial number to the table
-- 1. row_number()
-- 2. rank
-- 3. dense_rank

-- Row number
select row_number() over() slno,first_name from employees;  

select first_name,salary,department_id,row_number() over(order by salary desc) 'slno' from employees;
select first_name,salary,department_id,row_number() over() 'slno' from employees order by salary desc;

select first_name,salary,row_number() over(order by first_name desc) 'slno' from employees;

-- Rank
select first_name,salary,department_id,row_number() over(order by salary desc) 'slno',
rank() over(order by salary desc) 'rank'
from employees;

-- Dense Rank
select first_name,salary,department_id,row_number() over(order by salary desc) 'slno',
dense_rank() over(order by salary desc) 'dense rank'
from employees;

-- use rownumber,rank and dense rank for hire_date
select first_name,hire_date,row_number() over(order by hire_date) 'row',
rank() over(order by hire_date) 'rank',
dense_rank() over(order by hire_date) 'dense'
from employees;

-- select the member with rank 5 in above context
select c.first_name,c.hiredate,c.dense from (select first_name,year(hire_date)hiredate,
dense_rank() over(order by year(hire_date) desc) 'dense'
from employees)c where dense=5;

-- give ranking based on number of employees who joined in a year
select * from 
(select first_name,hire_date,year(hire_date),count(year(hire_date)) over(partition by year(hire_date)) 'count',
dense_rank() over(order by year(hire_date) desc) 'dense'
 from employees)c where dense=5;
 
 -- giving dense rank to coun

 select *,dense_rank() over(order by c.count desc) from 
(select first_name,hire_date,year(hire_date),count(year(hire_date)) over(partition by year(hire_date)) 'count'
 from employees)c;
 
-- Ntile function
-- this is used to split the table into parts
select ntile(3) over(order by department_id) 'ntile',first_name,department_id from employees;

-- Lag/Lead function
-- Lead will display the data of next row
-- Lag displays the data of the previous row
select first_name,lead(salary) over(order by salary) 'lead',salary,lag(salary) over(order by salary) 'lag' from employees; 
select first_name,lead(hire_date) over(order by hire_date) 'lead',hire_date,lag(hire_date) over(order by hire_date) 'lag' from employees; 

use hr;
select * from employees where job_id='ad_vp';

-- find the number of days difference between 1st and 2nd ad_vp job_id person
select first_name,leaddate,hire_date,abs(datediff(hire_date,leaddate)) 
from (select hire_date,first_name,lead(hire_date) over(order by hire_date) 'leaddate' from employees
where job_id='ad_vp')c limit 1;
 
-- find salary difference between 1st and 2nd person
select first_name,leadsal,salary,abs(leadsal-salary) 
from (select salary,first_name,lead(salary) over(order by salary) 'leadsal' from employees
where job_id='it_prog')c limit 1;
